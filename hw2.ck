// Machine.add(me.dir() + "/ks-chord.ck");
// 4::second => now;

me.dir() + "sounds/superball/" => string sb_dir;
me.dir() + "sounds/trem/" => string trem_dir;

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

class CombOptions {
    0.125 => float shiftMin;
    0.5 => float shiftMax;
    
    0.25 => float rateMin;
    0.75 => float rateMax;
    
    0.0 => float pan;
    
    60-12 => float tune1;
    64-12 => float tune2;
    72-12 => float tune3;
    79-12 => float tune4;
}

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

Dyno d1 => dac.left;
Dyno d2 => dac.right;
d1.compress();
d2.compress();

// object.feedback( .99 );
// 0.5 => object.gain;
// offset
-12 => int x;
// 24 => int x;
// tune
// object.tune( 60+x, 64+x, 72+x, 79+x );


fun void playSound(string filename, CombOptions opt) {
    getSound(filename) @=> SndBuf buf;
    buf => Dyno comp => PitShift p => NRev r => KSChord object => Pan2 pan;
    // set pannings
    pan.left => d1;
    pan.right => d2;
    
    object.feedback( .99 );
    0.5 => object.gain;

    Math.random2f(-1.0 * opt.pan, opt.pan) => pan.pan; 
    // -1.0 => pan.pan;
    // <<< pan.pan() >>>;

    
    Math.random2f(opt.shiftMin, opt.shiftMax) => p.shift;
    // Math.random2f(1, 3) => p.shift;
    Math.random2f(opt.rateMin, opt.rateMax) => buf.rate;
    // Math.random2f(0.75, 2) => buf.rate;
    
    object.tune(opt.tune1, opt.tune2, opt.tune3, opt.tune4);
    
    
    0.1 => buf.gain;
    0 => buf.pos;
        
    while (buf.pos() >= 0 && buf.pos() < buf.samples()) {
        //Math.random2f(.2,.5) => buf.gain;
        //Math.random2f(.5,1.5) => buf.rate;
        800::ms => now;
        if (maybe) {
            buf.rate() * 1.0 => buf.rate;
        }
    }
    
    5::second => now; // allow for the reverb to play out
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
playSoundRand(superballFiles, 5, 5::second, cmaj);
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


playSoundRand(superballFiles, 5, 4::second, bmin);
5::second => now;

0.75 => cmaj.pan;
playSoundRand(superballFiles, 5, 10::second, cmaj);

CombOptions testBottle;
0.0025 => testBottle.rateMin;
0.1 => testBottle.rateMax;
0.025 => testBottle.shiftMin;
0.2 => testBottle.shiftMax;
64 => testBottle.tune1 => testBottle.tune2 => testBottle.tune3 => testBottle.tune4;

spork~ playSoundRandSpork(tremFiles, 5, 4::second, testBottle);

spork~ playSoundRandSpork(superballFiles, 5, 1::second, cmaj);
5::second => now;

// spork~ playSoundRand(tremFiles, 17, 500::ms, testBottle);




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

