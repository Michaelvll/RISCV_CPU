MEMORY
{
	rom : ORIGIN = 0x00000000, LENGTH = 0x00001000
	ram : ORIGIN = 0x00001000, LENGTH = /*0x0000F000*/0x0FFFF000
}

SECTIONS
{
	.rom :
	{
		*(.rom)
	} > rom
	
	.text :
	{
		*(.text)
	} > ram
	
	.rodata :
	{
		*(.rodata)
	} > ram
	
	.data :
	{
		*(.data)
	} > ram
	
	.bss :
	{
		*(.bss)
	} > ram
}