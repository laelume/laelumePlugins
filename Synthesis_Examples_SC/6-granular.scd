s.boot;
FreqScope.new;

//three different possible grains
(
{
var singrain1, singrain2, sfgrain;
singrain1=SinOsc.ar(440,0,XLine.kr(1.0, 0.0001, 0.05));
singrain2=FSinOsc.ar(800, 0.0, Line.kr(1.0,0,0.05).squared);
sfgrain=(PlayBuf.ar(1,b.bufnum, BufRateScale.kr(b.bufnum)))*EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.01], -4));

[singrain1,singrain2,sfgrain]
}.plot(0.1,s)
)



( // Adds a sine grain synthdef to the server
SynthDef(\sinegrain, {arg pan, freq, amp; var grain;
grain= SinOsc.ar(freq, 0, amp)*(XLine.kr(1.001,0.001,0.1,doneAction:2)-0.001);
Out.ar(0,Pan2.ar(grain, pan))}).add;
)


// Single Grain
Synth(\sinegrain,[\freq,rrand(100,10000),\amp, exprand(0.05,0.1), \pan, 1.0.rand2]);


( // 100 random grains spaced by 0.01s intervals = 10s
{
100.do{
		arg i;
		Synth(\sinegrain,[
			\freq,rrand(100,10000),
			\amp,exprand(0.05,0.1),
			\pan, 1.0.rand2
		]);
		0.01.wait
	};
}.fork
)


( // "Swarm" of 200 random sine grains spaced by random intervals
{
200.do{
		arg i;
		var t_seed = (i/199)**3; // seed index follows a (1/x)**3 curve
		Synth(\sinegrain,[
			\freq,exprand(100,5000-(20*i)), // random frequencies on exponential curve based upon seed index
			\amp, exprand(0.05,0.1), // random amps
			\pan, 1.0.rand2 //random panning pattern
		]);
		rrand((t_seed*0.1).max(0.01),t_seed*0.3).wait // random triggering: fast when index is low, spaced out as index increases
	};
}.fork
)

//TODOOOOOOOOO
granular synthesis - FM
granular synthesis - Phasor
granulation - samples
pulsar synthesis
