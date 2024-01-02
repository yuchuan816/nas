const files = [
  '是，大臣 - S03E01 - 机会均等.mkv',
  '是，大臣 - S03E02 - 严峻挑战.mkv',
  '是，大臣 - S03E03 - 家丑外扬.mkv',
  '是，大臣 - S03E04 - 操守问题.mkv',
  '是，大臣 - S03E05 - 如坐针毡.mkv',
  '是，大臣 - S03E06 - 知易行难.mkv',
  '是，大臣 - S03E07 - 中产圈套.mkv',
]

const subtitles = [
  '是，大臣 - S03E01 - 机会均等.srt',
  '是，大臣 - S03E02 - 严峻挑战.srt',
  '是，大臣 - S03E03 - 家丑外扬.srt',
  '是，大臣 - S03E04 - 操守问题.srt',
  '是，大臣 - S03E05 - 如坐针毡.srt',
  '是，大臣 - S03E06 - 知易行难.srt',
  '是，大臣 - S03E07 - 中产圈套.srt',
]

const commands = files.map((fileName, index) => {
  const prefix = 'sudo docker compose exec -it mkvtoolnix sh -c';
  const content = [
    `/usr/bin/mkvmerge --ui-language zh_CN --priority lower --output '/shares/factory-movies//S01/JOJO的奇妙冒险S01E${index}.mkv' --language 0:ja --track-name 0: --display-dimensions 0:1920x1080 --language 1:ja '(' '/shares/factory-series/JoJo的奇妙冒险/S1/[DBD-Raws][BDrip][1080p]/[DBD-Raws][JOJO的奇妙冒险][01][1080P][BDRip][HEVC-10bit][FLAC].mkv' ')' --language 0:zh-Hans-CN --track-name '0:简体中文' --default-track-flag 0:no '(' '/shares/factory-series/JoJo的奇妙冒险/S1/[DBD-Raws][BDrip][1080p]/字幕 [简体中文]/[DBD-Raws][JOJO的奇妙冒险][01][1080P][BDRip][HEVC-10bit][FLAC].sc.ass' ')' --language 0:zh-Hant-TW --track-name '0:繁體中文' '(' '/shares/factory-series/JoJo的奇妙冒险/S1/[DBD-Raws][BDrip][1080p]/字幕 [繁体中文]/[DBD-Raws][JOJO的奇妙冒险][01][1080P][BDRip][HEVC-10bit][FLAC].tc.ass' ')' --attachment-name simhei.ttf --attachment-mime-type font/ttf --attach-file '/shares/factory-series/JoJo的奇妙冒险/S1/[DBD-Raws][BDrip][1080p]/Fonts/simhei.ttf' --track-order 0:0,0:1,1:0,2:0`
  ].join(' ');

  return `${prefix} "${content}"`
})

console.log(commands.join('\n'));
