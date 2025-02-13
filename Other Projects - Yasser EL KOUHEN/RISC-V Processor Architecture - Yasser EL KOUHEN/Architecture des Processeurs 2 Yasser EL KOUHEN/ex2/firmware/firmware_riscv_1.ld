stack_size = 256 ;
heap_size = 256 ;

MEMORY
{
  imem : o = 0x00000000, l = 4k
  rom  : o = 0x00010000, l = 4k
  ram : o = 0x00010800, l = 2k
}
SECTIONS
{
  .text :
 {
   __text_start = . ;
  KEEP (*(.start))
  *(.text)
  *(.text.*)
 
 }>imem

 .rodata :
 {
  *(.rodata)
  *(.rodata.*)
  *(.srodata)
  *(.srodata.*)
  . = ALIGN (4);
    __text_end =  . ;
 }>rom

.data :  AT (  __text_end )
 {
  . = ALIGN (4);	
   __data_start = . ;
  *(.data)
  *(.data.*)
  *(.sdata)
  *(.sdata.*)
  . = ALIGN (4);
   __data_end =  . ;
 }>ram

.init :
  {
   KEEP (*(SORT_NONE(.init)))
  }>imem

 .bss :
  {
  . = ALIGN (4);	
    __bss_start = . ;
   _gp = .;
   *(.bss)
   *(.bss.*)
   *(.sbss)
   *(.sbss.*)
   . = ALIGN (4);	
    __bss_end  = . ; 
  }>ram



 .heap :
  {
     . = ALIGN (4);
     heap_low = . ;
     . = . + heap_size;
     heap_top  = . ; 
    
  }>ram
 .stack :
  {
     . = ALIGN (4);
    __stack_start = . ;
     . = . + stack_size;
    __stack_end  = . ; 
    _sp = . ;
  }>ram


}

