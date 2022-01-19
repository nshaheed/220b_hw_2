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

fun void playSound(string filename) {
    getSound(filename) @=> SndBuf buf;
    buf => PitShift p => NRev r => dac;
    
    Math.random2f(0.125, 0.5) => p.shift;
    Math.random2f(0.25, 0.75) => buf.rate;
    0.2 => buf.gain;
    
    0 => buf.pos;
        
    while (buf.pos() >= 0 && buf.pos() < buf.samples()) {
        //Math.random2f(.2,.5) => buf.gain;
        //Math.random2f(.5,1.5) => buf.rate;
        800::ms => now;
        if (maybe) {
            buf.rate() * 1.0 => buf.rate;
        }
    }
}
   

// getSounds(superballFiles) @=> SndBuf superball[];

for(5 => int i; i > 0; i--) {
    for (0 => int j; j < 5; j++) {
        <<< i, j >>>;
        spork~ playSound(superballFiles[Math.random2(0,superballFiles.cap()-1)]);
        
        i::second => now;
    }
}

20::second => now;


