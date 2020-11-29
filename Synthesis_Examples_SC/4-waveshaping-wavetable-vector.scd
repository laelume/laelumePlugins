s.boot;
s.scope;
FreqScope.new;

// WAVETABLE SYNTHESIS: Store the wavetable in a buffer and pass through the oscillator. Needs to be a power of 2 and good range is 128-8192

b=Buffer.alloc(s, 2048);


( // One cycle of a sine wave converted to a wavetable
~sig = Signal.sineFill(1024, [1], [0]);
~wt = ~sig.asWavetable;
b.loadCollection(~wt).plot;
{Osc.ar(b, MouseX.kr(100,300,1), mul:0.2!2)}.scope;
)


( // One cycle of a sine wave not converted to a wavetable
~sig = Signal.sineFill(2048, [1], [0]);
// ~wt = ~sig.asWavetable;
b.loadCollection(~sig).plot;
{Osc.ar(b, MouseX.kr(100,300,1), mul:0.2!2)}.scope;
)


( // Using amplitude array for the partials
~amps= [1] ++ ({[0, exprand(0.05,0.5)].choose}!31);

~sig = Signal.sineFill(
	1024,
	~amps,
	0!32
);

~wt = ~sig.asWavetable;
b.loadCollection(~wt).plot;
)


// wavetable additive synthesis using array of partials
{Osc.ar(b, MouseX.kr(100,300,1), mul:0.2!2)}.scope;

// comparing to the sinosc multichannel additive synthesis
{SinOsc.ar(MouseX.kr(100,300,1)*(1..32),0,~amps*0.1).sum!2}.scope;


b.sine3([1],[1],[0],asWavetable:true);
b.sine3([1.25],[1],[0],asWavetable:true); // Using a discontinuous waveform (watch out for aliasing at high frequencies)
{Osc.ar(b, MouseX.kr(100,200,1), mul:0.2!2)}.scope;

b.sine3([1,50],[1,1],[0,0],asWavetable:true);

( // Buffer generated using randomness; each time it's triggered the Osc updates with the new wavetable values
b.sine3(
	({exprand(0.75,40)}!16).sort,
	({exprand(0.05,0.9)}!16).sort.reverse,
	{rrand(0,2pi)}!16,
	asWavetable:true
).plot;
)

( // Using an envelope to generate waveforms
var env, sig, wt;
env = Env([0,0.6,-0.9,0.3,0],[4,3,2,1],\lin); // \sine makes softer sound; \lin makes sharper sound

sig = env.asSignal(1024);
wt = sig.asWavetable;
b.loadCollection(wt);
)



( // Using randomness and envelope generators to make waveforms
var env, sig, wt, numSegs;
numSegs = rrand(4,20);
env = Env(
	(({rrand(0,1)}!(numSegs+1))*[1,-1]).scramble,
	{exprand(1,20)}!numSegs,
	{rrand(-20,20)}!numSegs
);

sig = env.asSignal(1024);
wt = sig.asWavetable;
b.loadCollection(wt);
)

{Osc.ar(b, MouseX.kr(100,4000,1)*[1,2.01], mul:0.2!2)}.scope;

//left off at 23:40 of https://www.youtube.com/watch?v=8EK9sq_9gFI

COsc()
VOsc()
Shaper()
Signal()