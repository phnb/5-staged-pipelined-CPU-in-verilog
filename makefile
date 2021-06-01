cpu:
	iverilog -o cpu test_CPU.v ALU.v ControlUnit.v CPU.v ForwardingUnit.v HazardDetection.v InstructionRAM.v MainMemory.v NumExtend.v PC.v PCAddr.v PipeReg_EXMEM.v PipeReg_IDEX.v PipeReg_IFID.v PipeReg_MEMWB.v RegFile.v
clean:
	rm -rf cpu