#!/usr/bin/env python
# Test the python gatttool version

import pygatt
import time

adapter = pygatt.GATTToolBackend()

try:
    adapter.start()
    print("Connecting...")
    device = adapter.connect('80:30:dc:d9:5a:a8')
    print("Turning light off")
    device.char_write_handle(0x002e, bytearray([0xcc, 0x24, 0x33]))

    time.sleep(5)
    print("Turning light on")
    device.char_write_handle(0x002e, bytearray([0xcc, 0x23, 0x33]))
finally:
    print("Disconnecting...")
    adapter.stop()
