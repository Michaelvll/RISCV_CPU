#ifndef CPU_JUDGE_ADAPTER_H
#define CPU_JUDGE_ADAPTER_H

#include "env_iface.h"
#include <bitset>

class Adapter
{
private:
	using byte = std::bitset<8>;
	enum States {
		IDLE,
		CHANNEL,
		LENGTH,
		DATA,
		END
	};
	static const uint8_t packet_size = 8;
	static const uint32_t message_bit = 72;
	
	States recv_state = IDLE;
	size_t recv_bit = 0, recv_packet_id = 0, send_packet_id = 1, recv_length = 0;
	std::bitset<message_bit> get_data;

	void data_handler(const std::vector<uint8_t> datas);
	void send(const uint32_t datas);
public:
	Adapter() : env(nullptr) {}

	void setEnvironment(IEnvironment *env) { this->env = env; }

	void onRecv(std::uint8_t data);

	//TODO: You may the following settings according to the UART implementation in your CPU
	std::uint32_t getBaudrate() { return 8000000; }
	serial::bytesize_t getBytesize() { return serial::eightbits; }
	serial::parity_t getParity() { return serial::parity_even; }
	serial::stopbits_t getStopBits() { return serial::stopbits_one; }

protected:
	IEnvironment *env;
};

#endif