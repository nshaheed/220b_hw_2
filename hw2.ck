// Machine.add(me.dir() + "/ks-chord.ck");
// 4::second => now;

me.dir() + "sounds/superball/" => string sb_dir;
me.dir() + "sounds/trem/" => string trem_dir;
me.dir() + "sounds/trem_slow/" => string trem_slow_dir;


[
sb_dir + "dehydrator_1.wav",
sb_dir + "dehydrator_2.wav",
sb_dir + "dehydrator_3.wav",
sb_dir + "mirror_1.wav",
sb_dir + "mirror_1.wav",
sb_dir + "mirror_1.wav",
sb_dir + "mirror_1.wav"
] @=> string superballFiles[];

[
trem_dir + "squeezebottle_1.wav",
trem_dir + "squeezebottle_2.wav",
trem_dir + "squeezebottle_3.wav"
] @=> string tremFiles[];

[
trem_slow_dir + "squeezebottle_1_25.wav"
] @=> string tremSlowFiles[];

fun SndBuf[] getSounds(string filenames[]) {
    SndBuf sounds[0];
   
    for (0 => int i; i < filenames.cap(); i++) {
        // the patch 
        SndBuf buf;
        // load the file
        filenames[i] => buf.read;
        sounds << buf;
    }
    
    return sounds;
}

fun SndBuf getSound(string filename) {
    // the patch 
    SndBuf buf;
    // load the file
    filename => buf.read;
    
    return buf;
}

fun void pitch(CombOptions opt, int p1) {
    p1 => opt.tune1 => opt.tune2 => opt.tune3 => opt.tune4;
}

/*
Dyno d1 => dac.left;
Dyno d2 => dac.right;
d1.compress();
d2.compress();
*/

// object.feedback( .99 );
// 0.5 => object.gain;
// offset
-12 => int x;
// 24 => int x;
// tune
// object.tune( 60+x, 64+x, 72+x, 79+x );

Envelope driver => blackhole;
1 => driver.value;
10 => driver.target;

fun void rampDriver() {
    2::minute => driver.duration;
    <<< "keyon" >>>;
    driver.keyOn();
    2::minute => now;
    driver.keyOn();
    2::minute => now;
}

fun void rampDriver(dur d, float target) {
    target => driver.target;
    d => driver.duration;
    
    driver.keyOn();
}

// spork~ rampDriver();


fun void playSound(string filename, CombOptions opt) {
    getSound(filename) @=> SndBuf buf;
    buf => Dyno comp => PitShift p => KSChord object => ABSaturator sat => NRev r => Pan2 pan;
    
    // nrev before or after kschord?
    // dyno on or off?
            
    <<< "~~~~~~~driver.value()~~~~~~", driver.value() >>>;
    driver.value() => sat.drive;
    0.25 => sat.gain;
    // 0.15 => sat.dcOffset;
    0.001 => sat.dcOffset;

    // set pannings
    /*
    pan.left => d1;
    pan.right => d2;
    */
    pan => dac;
    
    object.feedback( .99 );
    // object.feedback(0.0);
    0.5 => object.gain;
    
    opt.rmix => r.mix;

    Math.random2f(-1.0 * opt.pan, opt.pan) => pan.pan; 
    Math.random2f(opt.shiftMin, opt.shiftMax) => p.shift;
    Math.random2f(opt.rateMin, opt.rateMax) => buf.rate;
        
    object.tune(opt.tune1, opt.tune2, opt.tune3, opt.tune4);
    
    
    0.1 => buf.gain;
    0 => buf.pos;
        
    while (buf.pos() >= 0 && buf.pos() < buf.samples()) {
        800::ms => now;
        if (maybe) {
            buf.rate() * -1.0 => buf.rate;
            // <<< buf.rate(), buf.pos() $ float / buf.samples() $ float >>>;
        }
    }
    
    10::second => now; // allow for the reverb to play out
}
   
fun void playSoundRand(string files[], int count, dur delay, CombOptions opt) {
    for (0 => int i; i < count; i++) {
        <<< i+1 , "/", count, delay / second, opt.tune1 $ int, opt.tune2 $ int, opt.tune3 $ int, opt.tune4 $ int >>>;
        spork~ playSound(files[Math.random2(0,files.cap()-1)], opt);
        
        if (i != count -1) {
            delay => now;
        }
    }
    
    // 1::minute => now; // ensure everything finishes playing
}  

fun void playSoundRandSpork(string files[], int count, dur delay, CombOptions opt) {
    playSoundRand(files, count, delay, opt);
    30::second => now;
}


CombOptions cmaj;
rampDriver(1::samp, 0);

/*
playSoundRand(superballFiles, 7, 5::second, cmaj);
10::second => now;


// -10 => x;
// object.tune( 60+x, 63+x, 72+x, 79+x );


// spork~ playSoundRand(superballFiles, 5, 5::second, cmaj);

CombOptions emin;
0 => x;
x+64 => emin.tune1 => emin.tune2;
x+71 => emin.tune3;
x+79 => emin.tune4;
0.5 => emin.shiftMin;
0.75 => emin.shiftMax;
0.1 => emin.pan;
// 0.75 => emin.rateMin;
// 1.25 => emin.rateMax;

rampDriver(30::second, 10);
playSoundRand(superballFiles, 4, 5::second, emin);

5::second => now;


CombOptions gmaj;
x+67 => gmaj.tune1;  // g
x+74 =>  gmaj.tune2; // d
x+83 => gmaj.tune3;  // b
x+91 => gmaj.tune4;  // g
0.5 => gmaj.shiftMin;
1.25 => gmaj.shiftMax;
0.25 => gmaj.rateMin;
0.75 => gmaj.rateMax;
0.2 => gmaj.pan;

rampDriver(30::second, 17);
playSoundRand(superballFiles, 5, 4::second, gmaj);
5::second => now;


CombOptions bmin;
x+71 => bmin.tune1;  // b
x+78 =>  bmin.tune2; // fs
x+86 => bmin.tune3;  // d
x+95 => bmin.tune4;  // b
0.5 => bmin.shiftMin;
1.25 => bmin.shiftMax;
0.25 => bmin.rateMin;
0.75 => bmin.rateMax;
0.3 => bmin.pan;

rampDriver(60::second, 25);
playSoundRand(superballFiles, 15, 4::second, bmin);
5::second => now;


rampDriver(10::second, 5);
0.75 => cmaj.pan;
playSoundRand(superballFiles, 5, 10::second, cmaj);

CombOptions testBottle;
0.0025 => testBottle.rateMin;
0.1 => testBottle.rateMax;
0.025 => testBottle.shiftMin;
0.2 => testBottle.shiftMax;
64 => testBottle.tune1 => testBottle.tune2 => testBottle.tune3 => testBottle.tune4;

// spork~ playSoundRandSpork(tremFiles, 5, 4::second, testBottle);

5::second => now;

// spork~ playSoundRand(tremFiles, 17, 500::ms, testBottle);

*/



CombOptions testBottle;

0.0025 => testBottle.rateMin;
0.1 => testBottle.rateMax;

0.75 => testBottle.rateMin;
0.95 => testBottle.rateMax;

// 0.75 => testBottle.rateMin => testBottle.rateMax;


0.2 => testBottle.shiftMin;
0.5 => testBottle.shiftMax;


// 1 => testBottle.shiftMin => testBottle.shiftMax;

1 => testBottle.rmix;

0.75 => testBottle.pan;

64 => testBottle.tune1 => testBottle.tune2 => testBottle.tune3 => testBottle.tune4;

spork~ playSoundRandSpork(tremFiles, 5, 16::second, testBottle);
10::second => now;
spork~ playSoundRandSpork(tremFiles, 5, 8::second, testBottle);
10::second => now;

/*

testBottle.clone() @=> CombOptions cbottle;
testBottle.clone() @=> CombOptions ebottle;
testBottle.clone() @=> CombOptions cbottle_1;
testBottle.clone() @=> CombOptions gbottle;


pitch(cbottle, 59);
pitch(ebottle, 63);

pitch(cbottle_1, 51);
pitch(gbottle, 54);

spork~ playSoundRandSpork(tremFiles, 5, 4::second, cbottle);

500::ms => now;
spork~ playSoundRandSpork(tremFiles, 5, 2::second, ebottle);

500::ms => now;
spork~ playSoundRandSpork(tremFiles, 5, 2::second, cbottle_1);

testBottle.clone() @=> CombOptions bbottle;
pitch(bbottle, 70);

10::second => now;
// spork~ playSoundRandSpork(tremFiles, 5, 2::second, bbottle);

// 4::second => now;
spork~ playSoundRandSpork(tremFiles, 5, 2::second, gbottle);

testBottle.clone() @=> CombOptions dbottle;
testBottle.clone() @=> CombOptions fbottle;
pitch(dbottle,61);
pitch(fbottle,64);

spork~ playSoundRandSpork(tremFiles, 5, 4::second, dbottle);

500::ms => now;
spork~ playSoundRandSpork(tremFiles, 5, 2::second, fbottle);


10::second => now;
spork~ playSoundRandSpork(tremFiles, 4, 5::second, cbottle);

*/
3::minute => now;


// getSounds(superballFiles) @=> SndBuf superball[];

/*
for(5 => int i; i > 0; i--) {
    for (0 => int j; j < 5; j++) {
        <<< i, j >>>;
        spork~ playSound(superballFiles[Math.random2(0,superballFiles.cap()-1)]);
        
        i*2::second => now;
    }
}

30::second => now;
*/

