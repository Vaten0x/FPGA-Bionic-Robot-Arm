import time
from board import SCL, SDA
import busio
from adafruit_pca9685 import PCA9685


# This file will lift up the fingers of the robotic hand and then put it back to the original position one by one
try:
    # Set up I2C communication
    i2c = busio.I2C(SCL, SDA)

    # Set up the PCA9685 driver
    pca = PCA9685(i2c)
    pca.frequency = 50  # Standard frequency for servos (50Hz)

    # Function to calculate duty cycle for the servo
    def pulse_width_to_duty_cycle(pulse_width):
        # Convert pulse width (in microseconds) to PCA9685 duty cycle
        max_duty = 0xFFFF  # Max 16-bit duty cycle
        pulse_range = 1000000 / pca.frequency  # PWM period in microseconds
        return int((pulse_width / pulse_range) * max_duty)

    # Map angles (0° to 90°) to pulse widths (1000 μs to 2000 μs)
    def angle_to_pulse_width(angle):
        min_pulse = 1000  # Pulse width for 0°
        max_pulse = 2000  # Pulse width for 90°
        return min_pulse + (angle / 90.0) * (max_pulse - min_pulse)
    
    # List of channels for the fingers
    fingers = {
        "pinky": 0,
        "ring": 1,
        "middle": 2,
        "index": 3,
        "thumb": 4
    }

    # Gradually move servo from 90° to 0° for each finger pinky to thumb
    for finger, channel in fingers.items():
        servo_channel = pca.channels[channel]
        print("Starting servo movement from 90° to 0° with 0.2-second delay... for the " + finger + " finger")
    
        for angle in range(90, -1, -1):  # Loop from 90° to 0°
            pulse_width = angle_to_pulse_width(angle)
            duty_cycle = pulse_width_to_duty_cycle(pulse_width)
            servo_channel.duty_cycle = duty_cycle
            print(f"Moved to {angle}° (pulse width: {pulse_width} μs, duty cycle: {hex(duty_cycle)})")
            time.sleep(0.2)

    # Turn off all servos
    print("Turning off all servos")
    for channel in fingers.values():
        pca.channels[channel].duty_cycle = 0

except Exception as e:
    print(f"An error occurred: {e}")