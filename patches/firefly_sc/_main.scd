/**
This script exemplifies the use of SuperCollider on Bela.
When a project contains a `_main.scd` file, `sclang` is started
and the content of the file is executed.
If you want to interact with SuperCollider running on the board
from within the SuperCollider IDE on your computer, check out 
the 12-SuperCollider/remote examples instead.
Those files also include more code examples to interface with
Bela-specific UGens.
 */
s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.options.postln;

s.waitForBoot({

 	{
	var sig, onsets, soundGate, local;

	// perc = Saw.ar * Env.perc(0.01, 0.2, 0.3).kr(2);

	sig = FFT( LocalBuf(512), SoundIn.ar(0) );

	onsets = Onsets.kr(sig, 0.3, \rcomplex, 0.1, 2.5);

	local = 1;

	local = local + (LocalIn.kr(1) * 0.1);

	Pluck.ar(WhiteNoise.ar(0.8!2), local > 1, 100.reciprocal, 72.midicps.reciprocal, 3, Rand(0.01, 0.2));

	local = Phasor.kr(onsets, Poll.kr(onsets, local, \rate) / 1 / ControlRate.ir);

	LocalOut.kr(local);

	soundGate = Amplitude.kr(local) > 0.98;

	Pluck.ar(WhiteNoise.ar(0.8!2), soundGate, 100.reciprocal, 72.midicps.reciprocal, 3, 0.001);

	}.play(s);
	
});
