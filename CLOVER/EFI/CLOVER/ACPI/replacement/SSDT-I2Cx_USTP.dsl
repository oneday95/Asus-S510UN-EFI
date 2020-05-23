// Touchpad activation with VoodooI2C and HID satellite kexts
// SBFx patches are not needed because the HID kext falls into the polling mode
// after finding that APIC and GPIO are incompatible.
// If used with v2.3 VoodooI2C package, the kernel will panic upon wake from sleep. v2.2 or older is recommended.
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "hack", "elan", 0x00000000)
{
#endif
    External (_SB_.PCI0.I2C0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C1, DeviceObj)    // (from opcode)
    External (SMD0, FieldUnitObj)    // (from opcode)

    Scope (_SB.PCI0.I2C0)
    {
        If (LAnd (_OSI ("Darwin"), LEqual (SMD0, 0x02))) // Turn off the unused I2C0. This might fix issues with random stops in the touchpad. This is the code that causes kp.
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }
    }

    Scope (_SB.PCI0.I2C1)
    {
        If (_OSI ("Darwin"))
        {
            Name (USTP, One) // "Infinite click" fix.
            Name (SSCN, Package (0x03) // Assignment of SSCN and FMCN
            {
                0x0210, 
                0x0280, 
                0x1E
            })
            Name (FMCN, Package (0x03)
            {
                0x80, 
                0xA0, 
                0x1E
            })
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
