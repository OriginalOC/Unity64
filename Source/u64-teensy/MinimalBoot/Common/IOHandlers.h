// MIT License
// 
// Copyright (c) 2023 Travis Smith
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
// and associated documentation files (the "Software"), to deal in the Software without 
// restriction, including without limitation the rights to use, copy, modify, merge, publish, 
// distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom 
// the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or 
// substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#ifndef IOHANDLERS_H
#define IOHANDLERS_H

/* --- USB MIDI Feature Detection --------------------------------------- */
/* Unity64 requires Teensy USB Serial + MIDI mode or equivalent combination */

#if defined(USB_MIDI) || \
    defined(USB_MIDI_SERIAL) || \
    defined(USB_SERIAL_MIDI) || \
    defined(USB_MIDI_AUDIO) || \
    defined(USB_MIDI_AUDIO_SERIAL) || \
    defined(USB_MIDI_SERIAL_AUDIO)
/* All valid Teensy USB MIDI entry points */
extern usb_midi_class usbMIDI;
#define usbDevMIDI usbMIDI
#else
#if defined(UNITY64_UPPER_FIRMWARE)
  #ifndef USB_MIDI
    #error "Unity64 UPPER requires USB MIDI enabled (Serial + MIDI equivalent)"
  #endif
#endif
#endif

#ifdef MinimumBuild
   //from IOH_TeensyROM.c :
   uint8_t RegNextIOHndlr;
   volatile uint8_t doReset = false;
   const unsigned char *HIROM_Image = NULL;
   const unsigned char *LOROM_Image = NULL;

#else
   //Only in full build
   USBHost myusbHost;
   USBHub hub1(myusbHost);
   USBHub hub2(myusbHost);
   MIDIDevice_BigBuffer usbHostMIDI(myusbHost);
   USBDrive myDrive(myusbHost);
   USBFilesystem firstPartition(myusbHost);

   USBHIDParser hid1(myusbHost);
   USBHIDParser hid2(myusbHost);
   USBHIDParser hid3(myusbHost);  //need all 3?

   USBSerial USBHostSerial(myusbHost);   //update HostSerialType to match, defined in PN532_UHSU.h

   EthernetUDP udp;
   EthernetClient client;

   /* Teensy core >= 1.59 provides usbDevMIDI directly */
   #define nfcStateEnabled       0
   #define nfcStateBitDisabled   1
   #define nfcStateBitPaused     2
#endif

#define IOHNameLength 20  //limited by display location on C64

struct stcIOHandlers
{
  char Name[IOHNameLength];
  void (*InitHndlr)();
  void (*IO1Hndlr)(uint8_t Address, bool R_Wn);
  void (*IO2Hndlr)(uint8_t Address, bool R_Wn);
  void (*ROMLHndlr)(uint32_t Address);
  void (*ROMHHndlr)(uint32_t Address);
  void (*PollingHndlr)();
  void (*CycleHndlr)();
};

#ifndef MinimumBuild
   #include "IO_Handlers/IOH_MIDI.c"
   #include "IO_Handlers/IOH_Debug.c"
   #include "IO_Handlers/IOH_TeensyROM.c" 
   #include "IO_Handlers/IOH_TR_BASIC.c" 
   #include "IO_Handlers/IOH_Swiftlink.c"
   #include "IO_Handlers/IOH_ASID.c"
#endif
   #include "IO_Handlers/IOH_None.c"
   #include "IO_Handlers/IOH_EpyxFastLoad.c"
   #include "IO_Handlers/IOH_MagicDesk.c"
   #include "IO_Handlers/IOH_Dinamic.c"
   #include "IO_Handlers/IOH_Ocean1.c"
   #include "IO_Handlers/IOH_FunPlay.c"
   #include "IO_Handlers/IOH_SuperGames.c"
   #include "IO_Handlers/IOH_C64GameSystem3.c"
   #include "IO_Handlers/IOH_EasyFlash.c"
   #include "IO_Handlers/IOH_ZaxxonSuper.c"
   #include "IO_Handlers/IOH_GMod2.c"
   #include "IO_Handlers/IOH_MagicDesk2.c"

stcIOHandlers* IOHandler[] =
{
   &IOHndlr_None,
#ifndef MinimumBuild
   &IOHndlr_SwiftLink,
   &IOHndlr_MIDI_Datel,
   &IOHndlr_MIDI_Sequential,
   &IOHndlr_MIDI_Passport,
   &IOHndlr_MIDI_NamesoftIRQ,
   &IOHndlr_Debug,
   &IOHndlr_TeensyROM,
   &IOHndlr_ASID,
   &IOHndlr_TR_BASIC,
#endif
   &IOHndlr_EpyxFastLoad,
   &IOHndlr_MagicDesk,
   &IOHndlr_Dinamic,
   &IOHndlr_Ocean1,
   &IOHndlr_FunPlay,
   &IOHndlr_SuperGames,
   &IOHndlr_C64GameSystem3,
   &IOHndlr_EasyFlash,
   &IOHndlr_ZaxxonSuper,
   &IOHndlr_GMod2,
   &IOHndlr_MagicDesk2,
};

#endif /* IOHANDLERS_H */
