// Machine.add(me.dir() + "/ks-chord.ck");
// 4::second => now;

me.dir() + "sounds/superball/" => string sb_dir;

[
sb_dir + "dehydrator_1.wav",
sb_dir + "dehydrator_2.wav",
sb_dir + "dehydrator_3.wav",
sb_dir + "mirror_1.wav",
sb_dir + "mirror_1.wav",
sb_dir + "mirror_1.wav",
sb_dir + "mirror_1.wav"
] @=> string superballFiles[];


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

KSChord object => Dyno d => dac;
object.feedback( .99 );
0.5 => object.gain;
// offset
-12 => int x;
// 24 => int x;
// tune
object.tune( 60+x, 64+x, 72+x, 79+x );


fun void playSound(string filename) {
    getSound(filename) @=> SndBuf buf;
    buf => Dyno comp => PitShift p => NRev r => object;
    
    d.compress();
    

    
    Math.random2f(0.125, 0.5) => p.shift;
    // Math.random2f(1, 3) => p.shift;
    Math.random2f(0.25, 0.75) => buf.rate;
    // Math.random2f(0.75, 2) => buf.rate;
    
    
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
    
    1::second => now; // allow for the reverb to play out
}
   
fun void playSoundRand(string files[], int count, dur delay) {
    for (0 => int i; i < count; i++) {
        <<< i+1 , "/", count, delay / second >>>;
        spork~ playSound(files[Math.random2(0,files.cap()-1)]);
        
        delay => now;
    }
}  

spork~ playSoundRand(superballFiles, 5, 10::second);

50::second => now;

-10 => x;
object.tune( 60+x, 63+x, 72+x, 79+x );

spork~ playSoundRand(superballFiles, 5, 5::second);


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

