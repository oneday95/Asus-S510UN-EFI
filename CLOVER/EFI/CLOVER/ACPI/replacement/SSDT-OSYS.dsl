// Alternative to XOSI patch 2
// Directly assign 0x07DF of Windows 2015 to _OSI related code OSYS
// Delete all _OSI related ACPI renames in your config.plist: _OSI to XOSI, OSID to XSID, OSYS to Method
// Delete SSDT-XOSI.aml and SSDT-_OSI-XINI.aml
// Original SSDT by daliansky, 0x07E2 changed to 0x07DF by whatnameisit
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "ACDT", "OSYS", 0x00000000)
{
#endif
    External (OSYS, FieldUnitObj)    // (from opcode)

    Scope (_SB)
    {
        Device (PCI1) // This device does one thing which is to execute the OS patch or not depending on its _STA
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                If (CondRefOf (\OSYS))
                {
                    Store (0x07DF, OSYS) // Make the OS act like Windows 2015's 0x07DF
                }
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F) // Turn on the device which executes the OS patch
                }
                Else
                {
                    Return (Zero) // Turn off the device so the patch is not executed
                }
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
