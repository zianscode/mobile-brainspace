import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void generateWav(String path, double frequency, double duration, double volume, {bool isSquare = false}) {
  int sampleRate = 11025;
  int numSamples = (sampleRate * duration).toInt();
  int subchunk2Size = numSamples; // 8-bit mono has 1 byte per sample
  int chunkSize = 36 + subchunk2Size;

  var header = ByteData(44);
  // RIFF header
  header.setUint8(0, 0x52); // R
  header.setUint8(1, 0x49); // I
  header.setUint8(2, 0x46); // F
  header.setUint8(3, 0x46); // F
  header.setUint32(4, chunkSize, Endian.little);
  header.setUint8(8, 0x57); // W
  header.setUint8(9, 0x41); // A
  header.setUint8(10, 0x56); // V
  header.setUint8(11, 0x45); // E

  // fmt subchunk
  header.setUint8(12, 0x66); // f
  header.setUint8(13, 0x6d); // m
  header.setUint8(14, 0x74); // t
  header.setUint8(15, 0x20); // ' '
  header.setUint32(16, 16, Endian.little); // Subchunk1Size
  header.setUint16(20, 1, Endian.little); // AudioFormat = 1 (PCM)
  header.setUint16(22, 1, Endian.little); // NumChannels = 1
  header.setUint32(24, sampleRate, Endian.little); // SampleRate
  header.setUint32(28, sampleRate, Endian.little); // ByteRate
  header.setUint16(32, 1, Endian.little); // BlockAlign
  header.setUint16(34, 8, Endian.little); // BitsPerSample = 8

  // data subchunk
  header.setUint8(36, 0x64); // d
  header.setUint8(37, 0x61); // a
  header.setUint8(38, 0x74); // t
  header.setUint8(39, 0x61); // a
  header.setUint32(40, subchunk2Size, Endian.little);

  var data = Uint8List(44 + numSamples);
  data.setRange(0, 44, header.buffer.asUint8List());

  for (int i = 0; i < numSamples; i++) {
    double t = i / sampleRate;
    // Fade out decay
    double envelope = 1.0 - (i / numSamples);
    // Sine or Square wave
    double angle = 2 * pi * frequency * t;
    double sampleValue = isSquare
        ? (sin(angle) >= 0 ? 1.0 : -1.0)
        : sin(angle);
    // For 8-bit PCM, values are 0 to 255, with 128 as silence
    int byteVal = (128 + sampleValue * 127 * volume * envelope).toInt().clamp(0, 255);
    data[44 + i] = byteVal;
  }

  // Create parent directory if not exist
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(data);
}

void main() {
  generateWav('assets/audio/correct.wav', 1000.0, 0.15, 0.5); // 1000Hz Sine (high pitch ding)
  generateWav('assets/audio/incorrect.wav', 180.0, 0.25, 0.5, isSquare: true); // 180Hz Square wave (harsh buzz)
  // ignore: avoid_print
  print('Audio assets generated successfully!');
}
