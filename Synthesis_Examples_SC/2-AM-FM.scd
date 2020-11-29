s.boot;
FreqScope.new;

// Using the concept of control values to randomize frequency + amplitude
a = {arg freq=440, amp=0.1; SinOsc.ar(freq)*amp}.play
a.set(\freq,rrand(220,666), \amp, rrand(0.1,0.5))



( // Ring Modulation. Reminde me a bit of noises from Star Wars. Here, the carrier and modulator waves hav frequencies ranging from 440 to 3000 and 1 to 3000, controlled by the mouse pointer.
{
var carrier, modulator, f_car, f_mod;

f_car= MouseX.kr(440,3000,'exponential');
f_mod= MouseY.kr(1,3000,'exponential');

carrier= SinOsc.ar(f_car);
modulator= SinOsc.ar(f_mod);

carrier*modulator;
}.scope
)


// Amplitude Modulation. Sounds specifically alot like R2D2! Carrier wave is bumped up to be centered at 0.5, while modulator wave varies from 0.38 +/- 0.28, such that all output values are positive (>0).
(
{
var carrier, modulator, f_car, f_mod;

f_car= MouseX.kr(440,3000,'exponential');
f_mod= MouseY.kr(1,3000,'exponential');

carrier= SinOsc.ar(f_car)+0.5;
modulator= 0.28*SinOsc.ar(f_mod)+0.38;

carrier*modulator;
}.scope
)



// Frequency Modulation. The carrier frequency is itself modulated by a wave instead of the carrier wave being multiplied by another wave. there are 3 parameters of interest, namely the carrier & modulator frequencies, as well as the modulator "depth", i.e. the multiplier that scales the modulator's amplitude. The spectrum for this type of modulation is quite complex, and is described using Bessel functions.

(
var w, cfslider, mfslider, mdslider, synth;

w=Window("frequency modulation", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

cfslider= EZSlider(w, 300@50, "carrier frequency", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\c_f, ez.value)});
w.view.decorator.nextLine;

mfslider= EZSlider(w, 300@50, "modulator frequency", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\m_f, ez.value)});
w.view.decorator.nextLine;

mdslider= EZSlider(w, 300@50, "modulator depth", ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01), {|ez|  synth.set(\m_d, ez.value)});

w.front;

synth= {arg c_f=440, m_f=1, m_d=0.01;
SinOsc.ar(c_f + (m_d*SinOsc.ar(m_f)),0,0.25)
}.scope;
) // last tone of the recording is c_f=320, m_f=184, m_d=392.39




// FM synthesis using index parameter. Here, the carrier frequency is modulated by an index which indicates ratio of frequency deviation to the value of the modulation frequency. This can be thought of as a type of "intensity", or brightness, since the higher the index, the more energy there is in the side frequency bands off the fundamental.
(
var w, cfslider, mfslider, mindexslider, synth;

w=Window("frequency modulation", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

cfslider= EZSlider(w, 300@50, "carrier frequency", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\c_f, ez.value)});
w.view.decorator.nextLine;

mfslider= EZSlider(w, 300@50, "modulator frequency", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\m_f, ez.value)});
w.view.decorator.nextLine;

mindexslider= EZSlider(w, 300@50, "modulation index", ControlSpec(0.0, 10, 'linear', 0.01, 0.0), {|ez|  synth.set(\m_index, ez.value)});

w.front;

synth= {arg c_f=440, m_f=1, m_index=0;
SinOsc.ar(c_f + (m_index*m_f*SinOsc.ar(m_f)),0,0.25)
}.scope;
)



// FM synthesis using harmonicity parameter. Here, the carrier frequency is modulated by harmonicity, which is the ratio of frequency deviation to modulation frequency. This can be thought of as a type of "intensity", or brightness, since the higher the index, the more energy there is in the sidebands off the fundamental frequency.

({
var c_f, m_f, harmonicity, m_index;

c_f = 440;
harmonicity = MouseX.kr(0,10);
m_index = MouseY.kr(0.0,10.0);

m_f = c_f*harmonicity;

SinOsc.ar(c_f+(SinOsc.ar(m_f)*m_f*m_index), 0.0,0.1);

}.scope
)

// Phase modulation (phasor == phase vector). Also [PMOsc] A type of frequency modulation that loops over an interval. Arguments of the carrier wave are time-invariant.

(
{
var m_f, m_index, scale;

m_f = MouseX.kr(1,4000);
m_index =MouseY.kr(0,300);
scale = 2pi/(s.sampleRate);

// Phasor 0
SinOsc.ar(440, ( (m_f*m_index)*scale*SinOsc.ar(m_f)), 0.25)

// Phasor 1
// SinOsc.ar(0, Phasor.ar(0,440*scale,0,2pi)+( (m_f*m_index)*scale*SinOsc.ar(m_f)), 0.25)

}.scope
)

//Vibrato. Also [Vibrato] Slow frequency modulation.

// Feedback Modulation. Also [SinOscFB] Some of the output is cycled back into the frequency input.

wave terrain synthesis, CMT
modal synthesis
karplus strong
resonance
pulsar synthesis masking




s.record;
s.stopRecording;

