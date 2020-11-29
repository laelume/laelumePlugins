s.boot;
FreqScope.new;

( // Amplitude (volume) envelope for generating a 3 second linear fadeout. FOr envelopes, and many other effects that don't explicitly generate the audio or DSP, using kr (control rate) takes up less CPU so try to use when possible instead of ar (audio rate). Use the argument doneAction:2 to kill the process so there aren't hidden dead synths in the background taking up processing power.
{
	var fadeout = EnvGen.kr(Env([1,0],[3]),doneAction:2);
	SinOsc.ar*fadeout
}.scope
)

( // Envelope as a frequency argument. Simple SinOsc was kind of boring so I modulated by a saw wave, turned out kind of unexpected!
{
	var fadeout = EnvGen.kr(Env([1,0],3));
	var filter = EnvGen.kr(Env([1234,600],[3]),doneAction:2); // Only need to call doneAction once per synth

	// Version 0
	// SinOsc.ar(filter)

	// Version 1
	// SinOsc.ar(filter)*Saw.ar

	// Version 2
	// SinOsc.ar(filter)*Saw.ar(fadeout)

	// Version 3
	// Saw.ar(filter,fadeout)

	// Version 4
	// Saw.ar(filter,fadeout)*SinOsc.ar

	// Version 4 -- note the difference in sound when the SinOsc is changed from ar to kr! A bit more raspy sounding.
	Saw.ar(filter,fadeout)*SinOsc.kr

}.scope
)

(// Different envelope syntax, same results
{
	var fadeout = Line.kr(1,0,3); // linear ... line
	var filter = XLine.kr(1234,600,3,doneAction:2); // exponential line generator

	//Version 0
	// Saw.ar(filter,fadeout)*SinOsc.kr

	// Version 1
	// Saw.ar(filter,fadeout)*SinOsc.ar(123)

	// Version 2
	Saw.ar(filter,fadeout)*SinOsc.ar(1337)

}.scope
)

( // Using gate values to set the envelope amplitude

e = Env([0.5,2,0],[0.5,1],0,1); // Envelope segments go from 0.5 to 2 in 0.5s, then 2 to 0 in 1s; releaseNode is 0 (first value in [levels]), loopNode is 1 (2nd value in [levels]. Env stays at loopNode until it is released, then moves onto next node and final part of envelope (here, a fadeout over 1s).

a = {
	arg gate=1; // Gate set to 1 (envelope ON while >0)
	EnvGen.ar(e,gate,doneAction:2)*SinOsc.ar*0.1
}.scope
)
a.set(\gate, 0); // Trigger this to set the gate to zero (envelope OFF)


// Looping envelopes

e = Env([0.0,0.0,1.0,0.0],[0.5,1.0,2.0],0,2,0); //releaseNode at 2, loopNode at 0
// Version 0
// a= {arg gate=1; EnvGen.ar(e,gate,doneAction:2)}.scope
// Version 1
a= {arg gate=1; EnvGen.ar(e,gate,doneAction:2)*SinOsc.ar(200)}.scope
a.set(\gate, 0); //takes 2.0 seconds to fade out


// Fast looping envelope almost sounds like audio rate; use mouse to check out timescale options

e = Env([0.0,1.0,-1.0,0.0],[0.01,0.01,2.0],0,2,0); //releaseNode at 2, loopNode at 0
a= {arg gate=1; EnvGen.ar(e,gate,timeScale:MouseX.kr(0.1,2.0),doneAction:2)}.scope
a.set(\gate, 0); //stops immediately since release transition to 0.0 occurs over 2 seconds, too slow to be a pitched oscillation


waveshaping:
chebyshev
clarinet
exponential transfer function
pong - wavefolding
waveshaping - simple, sines, even odd