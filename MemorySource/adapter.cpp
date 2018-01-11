#include "adapter.h"
#include <iostream>
#include <iomanip>


void Adapter::data_handler(const std::vector<uint8_t> datas)
{
	// Only send 1 byte every time
	if (datas.size() == 5 && datas[4] == 0) {
		uint32_t addr = datas[0] | datas[1] << 8 | datas[2] << 16 | datas[3] << 24;
		uint32_t word = env->ReadMemory(addr);
		std::clog << "Get read request: ADDR:0x"
			<< std::hex << std::setw(8) << std::setfill('0')
			<< addr << ", Get Data: 0x" 
			<< std::hex << std::setw(8) << std::setfill('0') << word << std::endl;

		send(word);
	}
	else if (datas.size() == 9) {
		uint32_t wdata = datas[0] | datas[1] << 8 | datas[2] << 16 | datas[3] << 24;
		uint32_t addr = datas[4] | datas[5] << 8 | datas[6] << 16 | datas[7] << 24;

		std::clog << "Get write request: ADDR: 0x"
			<< std::hex << std::setw(8) << std::setfill('0')
			<< addr << ", DATA: 0x" << wdata;
		std::clog << ", MASK: " << std::bitset<4>(datas[8]) << std::endl;
		if (addr == 0x104) {
			std::cout << datas[0] << std::endl;
		}
		env->WriteMemory(addr, wdata, datas[8]);
	}
}

void Adapter::send(const uint32_t datas)
{
	std::vector<uint8_t> send_data;
	send_data.push_back(uint8_t((0x4 << (packet_size - 3)) | (send_packet_id & 0x1f)));
	send_data.push_back(uint8_t((0x5 << (packet_size - 3)) | 0));
	send_data.push_back(uint8_t((0x6 << (packet_size - 3)) | 4));
	for (int i = 0; i < 5; ++i) {
		send_data.push_back(uint8_t(datas >> (i * 7) & 0x7f));
	}
	send_data.push_back(uint8_t((0x7 << (packet_size - 3)) | (send_packet_id & 0x1f)));
	++send_packet_id;

	std::clog << "Send Data: ";
	for (auto x : send_data) {
		std::clog << std::hex << std::setw(2) << std::setfill('0') << uint32_t(x) << ' ';
	}
	std::clog << std::endl;
	env->UARTSend(send_data);
}

void Adapter::onRecv(std::uint8_t data) {
  // TODO: Do something when you receive a byte from your CPU
  //
  // You can access the memory like this:
  //    env->ReadMemory(address)
  //    env->WriteMemory(address, data, mask)
  // where
  //   <address>: the address you want to read from / write to, must be aligned
  //   to 4 bytes <data>:    the data you want to write to the <address> <mask>:
  //   (in range [0x0-0xf]) the bit <i> indicates that you want to write byte
  //   <i> of <data> to address <address>+i
  //              for example, if you want to write 0x2017 to address 0x1002,
  //              you can write env.WriteMemory(0x1000, 0x20170000, 0b1100)
  // NOTICE that the memory is little-endian
  //
  // You can also send data to your CPU by using:
  //    env->UARTSend(data)
  // where <data> can be a string or vector of bytes (uint8_t)

	//std::clog << "Get Data: 0x" << std::hex << std::setw(2) << std::setfill('0') << uint32_t(data) << std::endl;
	uint8_t packet_id = 0;
	byte recv_data(data);
	switch (recv_state) {
	case IDLE:
		get_data = 0;
		if ((data >> (packet_size - 3)) == 0x4) {
			packet_id = data & 0x1f;
			if (packet_id != ((recv_packet_id + 1) & 0x1f)) {
				std::cerr << "Lose Packet from "
					<< ((recv_packet_id + 1) & 0x1f)
					<< "-" << uint32_t(packet_id) << std::endl;
			}
			recv_bit = 0;
			recv_length = 0;
			recv_state = CHANNEL;
		}
		else
			std::cerr << "Corrupted Packet at IDLE" << std::endl;
		//std::clog << "AT IDLE\n" << std::endl;
		break;
	case CHANNEL:
		if ((data >> (packet_size - 3)) == 0x5) {
			recv_state = LENGTH;
		}
		else {
			recv_state = IDLE; 
			std::cerr << "Corrupted Packet at CHANNEL" << std::endl;
		}
		//std::clog << "AT CHANNEL\n" << std::endl;
		break;
	case LENGTH:
		if ((data >> (packet_size - 3)) == 0x6) {
			recv_length = (data & 0x1f)*8;
			recv_state = DATA;
			std::clog << "Get length: " <<std::dec<< recv_length << std::endl;
		}
		else {
			recv_state = IDLE;
			std::cerr << "Corrupted Packet at LENGTH" << std::endl;
		}
		//std::clog << "AT LENGTH\n" << std::endl;
		break;
	case DATA:
		if ((data >> (packet_size - 1)) == 0x0) {
			for (size_t i = 0; i < 7 && recv_bit < recv_length; i++, recv_bit++) {
				get_data[recv_bit] = (data & (1 << i)) ? 1 : 0;
			}
			//std::clog << "Recv_bit: " << std::dec << recv_bit << std::endl;
			if (recv_bit == recv_length)
				recv_state = END;
		}
		else {
			recv_state = IDLE;
			std::cerr << "Corrupted Packet at DATA" << std::endl;
		}
		//std::clog << "AT DATA\n" << std::endl;
		break;
	case END:
		if ((data >> (packet_size - 3)) == 0x7) {
			packet_id = (data & 0x1f);
			if (((recv_packet_id + 1)&0x1f) == packet_id) {
				recv_packet_id = packet_id;
				std::vector<uint8_t> result;
				for (size_t i = 0; i < recv_bit; i += 8) {
					uint8_t tmp = 0;
					for (size_t j = 0; j < 8; ++j) {
						tmp |= get_data[i + j] << j;
					}
					//std::clog << "Get tmp: 0x" << std::hex << std::setw(2) << std::setfill('0') << uint32_t(tmp) << std::endl;
					result.push_back(tmp);
				}
				data_handler(result);
			}
			else {
				std::cerr << "Packet id incorrect: " << uint32_t(packet_id) << std::endl;
			}
		}
		else {
			std::cerr << "Corrupted Packet at END" << std::endl;
		}
		recv_state = IDLE;
		//std::clog << "AT END\n=====================\n" << std::endl;
		break;
	}
}