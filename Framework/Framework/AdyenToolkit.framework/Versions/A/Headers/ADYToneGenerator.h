//
//  ADYToneGenerator
//
//  Created by Taras Kalapun

/*
 
 - When a card has been presented and read successfully, a success tone (single beep) should be sounded; The success tone shall be a single ‘beep’ with a frequency of approximately 1500 Hertz, sine wave shape and duration of approximately 500ms.
 - When the reader indicates a requirement to switch interfaces, an alert tone (double beep) should be sounded; The alert tone shall be a double ‘beep’ with a frequency of approximately 750 Hertz, sine wave shape. Each ‘beep’ shall have a duration of approximately 200ms with a gap between the two ‘beeps’ of approximately 200ms.
 
 */

#import <Foundation/Foundation.h>

#define SINE_WAVE_TONE_GENERATOR_FREQUENCY_DEFAULT 440.0f

#define SINE_WAVE_TONE_GENERATOR_SAMPLE_RATE_DEFAULT 44100.0f

#define SINE_WAVE_TONE_GENERATOR_AMPLITUDE_LOW 0.01f
#define SINE_WAVE_TONE_GENERATOR_AMPLITUDE_MEDIUM 0.02f
#define SINE_WAVE_TONE_GENERATOR_AMPLITUDE_HIGH 0.03f
#define SINE_WAVE_TONE_GENERATOR_AMPLITUDE_FULL 0.25f
#define SINE_WAVE_TONE_GENERATOR_AMPLITUDE_DEFAULT 1.0f

#define ALERT_SUCCESS_FREQUENCY 1500.0f // Hertz
#define ALERT_SUCCESS_DURATION 500      // ms

#define ALERT_SWITCH_FREQUENCY 750.0f   // Hertz
#define ALERT_SWITCH_DURATION 200       // ms
#define ALERT_SWITCH_GAP 200            // ms

typedef struct {
    double frequency;
    double theta;
} ADYToneInfo;

@interface ADYToneGenerator : NSObject

- (void)alertSuccess;
- (void)alertSwitch;

+ (void)alertSuccess;
+ (void)alertSwitch;

@end
