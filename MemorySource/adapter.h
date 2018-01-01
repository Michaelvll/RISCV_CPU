#ifndef CPU_JUDGE_ADAPTER_H
#define CPU_JUDGE_ADAPTER_H

#include "env_iface.h"
#include <bitset>
#include <queue>

class Adapter
{
private:
	using byte = std::bitset<8>;
	static enum States {
		IDLE,
		CHANNEL,
		LENGTH,
		DATA,
		END
	};
	const uint8_t pakcet_size = 8;
	States recv_state = IDLE;
	byte recv_bit = 0, recv_packet_id = 0, recv_length = 0;
	std::queue<byte> read_buffer;
public:
	Adapter() : env(nullptr) {}

	void setEnvironment(IEnvironment *env) { this->env = env; }

	void onRecv(std::uint8_t data);

	//TODO: You may the following settings according to the UART implementation in your CPU
	std::uint32_t getBaudrate() { return 9600; }
	serial::bytesize_t getBytesize() { return serial::eightbits; }
	serial::parity_t getParity() { return serial::parity_none; }
	serial::stopbits_t getStopBits() { return serial::stopbits_one; }

protected:
	IEnvironment *env;
};

#endif