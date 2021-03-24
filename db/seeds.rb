# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Genre.create!(
 [
  {
   name: "文学・評論"
  },
  {
   name: "ノンフィクション"
  },
  {
   name: "ビジネス・経済"
  },
  {
   name: "歴史・地理"
  },
  {
   name: "政治・社会"
  },
  {
   name: "芸能・エンターテインメント"
  },
  {
   name: "アート・建築・デザイン"
  },
  {
   name: "人文・思想・宗教"
  },
  {
   name: "暮らし・健康・料理"
  },
  {
   name: "サイエンス・テクノロジー"
  },
  {
   name: "趣味・実用"
  },
  {
   name: "教育・自己啓発"
  },
  {
   name: "スポーツ・アウトドア"
  },
  {
   name: "辞典・年鑑・本・ことば"
  },
  {
   name: "音楽"
  },
  {
   name: "旅行・紀行"
  },
  {
   name: "絵本・児童書"
  },
  {
   name: "コミックス"
  }
  ]
 )

User.create!(
 [
  {
  nickname: "あお",
  email: "ao@ao",
  password: "aoaoaoao",
  introduction: "主に小説を中心に読みます。まったり、読んでいて気づいたことなどを投稿しようと思います。よろしくお願いします。"
  },
  {
  nickname: "ミッキー",
  email: "mickey@mickey",
  password: "mickeymickey",
  introduction: "35歳の専業主婦です。家事と育児の合間に読むことが多いです。"
  },
  {
  nickname: "陽子",
  email: "youko@youko",
  password: "youkoyouko",
  introduction: "読書は私にとっての癒しです😊"
  },
  {
  nickname: "なおきち",
  email: "naokichi@naokichi",
  password: "naokichi@naokichi",
  introduction: "大学時代は文学を専攻していました。文学ガチ勢です。小説の考察を中心に投稿してます！"
  },
  {
  nickname: "haru",
  email: "haru@haru",
  password: "haruharu",
  introduction: "本はあまり読みできませんでしたが、このサイトを利用して習慣にできればなぁと考えてます⭐️"
  },
  {
  nickname: "かまいたち",
  email: "kamaitachi@kamaitachi",
  password: "kamaitachikamaitachi@",
  introduction: "気になる方はフォローします！よろしくお願いします！！"
  },
  {
  nickname: "マイマイ",
  email: "mai@mai",
  password: "maimaimai",
  introduction: "本は電子書籍で読む派です。"
  },
  {
  nickname: "rock22",
  email: "rock22@rock22",
  password: "rock22rck22",
  introduction: "ともかく面白い本に出会いたい！！"
  },
  {
  nickname: "mmzz",
  email: "mmzz@mmzz",
  password: "mmzzmmzz",
  introduction: "本屋で2時間くらい過ごせちゃいます。"
  },
  {
  nickname: "カリー",
  email: "kari@kari",
  password: "karikari",
  introduction: "文学部専攻の学生です！みなさんの考察を参考にさせてください！"
  },
  {
  nickname: "ootani",
  email: "ootani@ootani",
  password: "ootaniootani",
  introduction: "気ままに投稿していまーす"
  },
  {
  nickname: "りんご",
  email: "ringo@ringo",
  password: "ringoringo",
  introduction: "続きが気になって眠れなくなるような作品に出会えればなと思ってます。"
  }
 ]
)

Book.create!(
 [
  {
   user_id: 1,
   genre_id: 1,
   book_title: "ロング・グッドバイ",
   author: "レイモンド・チャンドラー",
   note: "村上春樹さんの訳",
   read_date: "2020/10/15"
  },
  {
   user_id: 2,
   genre_id: 1,
   book_title: "レベル7",
   author: "宮部みゆき",
   note: "サスペンス系",
   read_date: "2020/11/17"
  },
  {
   user_id: 3,
   genre_id: 1,
   book_title: "忘たれた巨人",
   author: "カズオ・イシグロ",
   note: "めちゃくちゃ面白かった。サスペンス系",
   read_date: "2020/12/28"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "誰がために鐘は鳴る上",
   author: "ヘミングウェイ",
   note: "新潮文庫、高見浩さん訳",
   read_date: "2021/01/05"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "誰がために鐘は鳴る下",
   author: "ヘミングウェイ",
   note: "新潮文庫、高見浩さん訳",
   read_date: "2021/01/10"
  },
  {
   user_id: 5,
   genre_id: 12,
   book_title: "文系でも仕事に使える統計学 はじめの一歩",
   author: "本丸諒",
   note: "確かに文系でもわかりやすかったと思う",
   read_date: "2021/02/23"
  },
  {
   user_id: 6,
   genre_id: 10,
   book_title: "HTML&CSSとWebデザイン",
   author: "Mana",
   note: "めっちゃわかりやすかった",
   read_date: "2021/02/15"
  },
  {
   user_id: 7,
   genre_id: 3,
   book_title: "ジョブ理論",
   author: "クレイトン・M・クリステンセン",
   note: "様々な業種が競合他社になる可能性を実感",
   read_date: "2020/11/15"
  },
  {
   user_id: 8,
   genre_id: 10,
   book_title: "Rによるテキストマイニング入門",
   author: "石田基広",
   note: "なかなかわかりやすい",
   read_date: "2020/11/10"
  },
  {
   user_id: 9,
   genre_id: 16,
   book_title: "遠い太鼓",
   author: "村上春樹",
   note: "ギリシャとイタリアで著者が過ごした話。めちゃくちぁ面白い",
   read_date: "2021/02/03"
  },
  {
   user_id: 10,
   genre_id: 8,
   book_title: "ヨーロッパの仏陀 -ニーチェの問-",
   author: "新田章",
   note: "非常に難しい",
   read_date: "2020/11/19"
  },
  {
   user_id: 11,
   genre_id: 14,
   book_title: "インドネシア語レッスン初級",
   author: "ホラス由美子",
   note: "数ページで挫折しました。。。",
   read_date: "2020/12/19"
  },
  {
   user_id: 12,
   genre_id: 3,
   book_title: "戦略的FTA活用ハンドブック",
   author: "嶋正和",
   note: "業務で使用",
   read_date: "2021/01/19"
  },
  {
   user_id: 2,
   genre_id: 1,
   book_title: "ティファニーで朝食を",
   author: "トルーマン・カポーティ",
   note: "なかなか感動",
   read_date: "2021/02/05"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "コトラーのマーケティング4.0",
   author: "フィリップ・コトラー",
   note: "けっこう目から鱗の感じ",
   read_date: "2021/03/2"
  },
  {
   user_id: 6,
   genre_id: 12,
   book_title: "統計学入門",
   author: "東京大学出版",
   note: "初歩的で根幹から理解できる",
   read_date: "2021/02/22"
  },
  {
   user_id: 8,
   genre_id: 16,
   book_title: "地球の歩き方 アメリカ",
   author: "ダイヤモンド社",
   note: "コロナが収束したら、早く旅行に行きたい◎",
   read_date: "2021/01/22"
  },
  {
   user_id: 10,
   genre_id: 1,
   book_title: "死の家の記録",
   author: "ドフトエフスキー",
   note: "実体験に基づいているのでとても面白い",
   read_date: "2021/01/12"
  },
  {
   user_id: 4,
   genre_id: 8,
   book_title: "嫌われる勇気",
   author: "岸見一郎 古賀史健",
   note: "面白い。アドラー心理学に関する本",
   read_date: "2020/12/16"
  },
  {
   user_id: 4,
   genre_id: 3,
   book_title: "道は開ける",
   author: "D・カーネギー",
   note: "面白い",
   read_date: "2021/01/18"
  },
  {
   user_id: 4,
   genre_id: 3,
   book_title: "人を動かす",
   author: "D・カーネギー",
   note: "誕生日に連絡するのは大事",
   read_date: "2021/02/26"
  },
  {
   user_id: 4,
   genre_id: 2,
   book_title: "心臓を貫かれて上",
   author: "M・ギルモア",
   note: "村上春樹さんの訳",
   read_date: "2020/10/12"
  },
  {
   user_id: 4,
   genre_id: 2,
   book_title: "心臓を貫かれて下",
   author: "M・ギルモア",
   note: "村上春樹さんの訳",
   read_date: "2020/10/18"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "ねじまき鳥クロニクル 〈第1部〉泥棒かささぎ編",
   author: "村上春樹",
   note: "面白い",
   read_date: "2020/11/08"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "ねじまき鳥クロニクル〈第2部〉予言する鳥編",
   author: "村上春樹",
   note: "面白い",
   read_date: "2020/11/15"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "ねじまき鳥クロニクル〈第3部〉鳥刺し男編",
   author: "村上春樹",
   note: "面白い",
   read_date: "2020/12/18"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "さよなら、愛しい人",
   author: "レイモンド・チャンドラー",
   note: "面白い",
   read_date: "2021/01/26"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "大いなる眠り",
   author: "レイモンド・チャンドラー",
   note: "面白い",
   read_date: "2021/01/30"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "ダンス・ダンス・ダンス上",
   author: "村上春樹",
   note: "これもかなり面白い",
   read_date: "2020/11/12"
  },
  {
   user_id: 4,
   genre_id: 1,
   book_title: "ダンス・ダンス・ダンス下",
   author: "村上春樹",
   note: "これもかなり面白い",
   read_date: "2020/11/28"
  },
  {
   user_id: 4,
   genre_id: 10,
   book_title: "一番やさしいITパスポート",
   author: "高橋京介",
   note: "面白い",
   read_date: "2020/12/20"
  },
  {
   user_id: 4,
   genre_id: 10,
   book_title: "基本情報処理技術者",
   author: "きたみりゅうじ",
   note: "わかりやすい",
   read_date: "2021/03/05"
  }
  ]
 )

 PostBook.create!(
 [
  {
   user_id: 1,
   genre_id: 1,
   title: "ハードボイルド小説の元祖",
   content: "主人公の私立探偵である、フィリップ・マーロウが様々な事件を解決するミステリー小説。
   村上春樹さんが、確か数年前に全作品（長編小説）を訳し終えたことでも有名です・
   しかし、ミステリー要素としての魅力以上に、小説そのものが醸し出すハードボイルド感がたまらない作品です。
   読んでいると、どこか自分もタフになれたような気がしてきます。（007やボーンシリーズを見た後の感じに似ていますね。。。）
   特に、「タフでなければ生き残れない、優しくなければ生きている価値がない」
   のセリフはよくに有名なセリフだと思います。フィリップ・マーロウのように生きてみたい。 ",
   post_book_title: "ロング・グッドバイ 他6編",
   post_book_author: "レイモンド・チャンドラー",
   post_book_image_id: nil
   },
   {
   user_id: 4,
   genre_id: 3,
   title: "これからのマーケティングとは",
   content: "人口に膾炙したシリーズだと思います。ひと昔前までは、大量消費大量生産の時代で、お客さんもテレビのCMなどで
   見た商品を購入していたので、広告に投資できる企業が生き残ってきました。しかし、高度にインターネットが発達した現代では、
   Eコマースが主要な流通業者となりつつあり、そこでは商品のレビューを見ることができるようになりました。また、SNSの発信なども
   ある中で、消費者はますます企業のいうことを信じなくなり、第三者が投稿した内容を基準に商品を選択するようになってきています。
   逆に言えば、ものがよければ勝手にクチコミまれて売れる時代でもあるので、真面目なモノづくりの重要性も強くなってきているのかななんて
   思いました。そのあたりの内容を考えさせられる本でした。",
   post_book_title: "コトラーのマーケティング4.0",
   post_book_author: "フィリップ・コトラー",
   post_book_image_id: nil
   },
   {
   user_id: 6,
   genre_id: 1,
   title: "女のいない男たちが伝えたかったこと",
   content: "大切な女性をなんらかの形で失ってしまった、悲しい男達の話。
   よく世間一般でも、「女は上書き保存、男は名前をつけて保存」を言われるように、
   どことなく次の一歩を踏み出せずに彷徨う男の心情を表現されているのかなと感じました。
   特に男性の方におすすめの作品です。",
   post_book_title: "女のいない男たち",
   post_book_author: "村上春樹",
   post_book_image_id: nil
   },
   {
   user_id: 8,
   genre_id: 3,
   title: "マーケティングに数学の力を掛け算した本",
   content: "この本は、マーケティングに携わる方は必見だと思います。
   特に著者のマーケテンングに対する考え方として、マーケティングが成功するかどうかは確率の問題であり、
   数字に裏付けられた最も確度の高い戦略を実践することるとが大切である、という店には深く共感しました。
   また、売り上げがどん底だったUSJをどのようにして再興したかが実例とともに記載されているので、
   大変勉強になりました。さらに、巻末に実際に使用された数学モデルに関して記載がありますので、
   数学がめちゃくちゃできる方は実務に早速活用することができると思います。",
   post_book_title: "確立思考の戦略論",
   post_book_author: "森岡毅 今西聖貴",
   post_book_image_id: nil
   },
   {
   user_id: 8,
   genre_id: 8,
   title: "アドラー心理学を初歩を学習",
   content: "アドラー心理学に関して全く知らなかったのですが、目から鱗の内容でした。
   また個人的には、哲学というよりも一つの生き方に関して述べられた本なのかなを感じています。
   アドラー心理学では、あらゆる上下構造（親子関係さえも）否定し、承認欲求を捨てることから
   始まるそうです。そのため、日本で特に行われている報酬型の学校教育は批判の対象となります。
   確かに、褒められることに快感を覚えると大人になってからも承認欲求でしか自己を満たすことができないようになり、
   結果的に他者依存の生き方になってしまうのかもしれません。でも、現代はSNSの発展により、一般人が
   世界に向けて情報発信できるようになっています。ある意味、自己承認欲求を満たすツールは肥大化しており、
   ますます他者依存の考え方は強まっている気もします。一方で、そんな考えた方に疲れているのも事実で、
   だからこそ人気が出たのかなと思いました。",
   post_book_title: "嫌われる勇気",
   post_book_author: "岸見一郎 古賀史健",
   post_book_image_id: nil
   },
   {
   user_id: 10,
   genre_id: 10,
   title: "Pythonのスクレイピングに関して勉強できます！",
   content: "会社でECのレビューを対象に分析する機会があり、
   何とかして自動化できないかと思いこちらの本で勉強しました。
   本書では、いくつかの方法が紹介されており、中でもScrapyに関しては実際に
   実装してスクレイピングすることができました。また、スクレイピング・クローリング
   に関しては、いろいろと規約や規則がありますので、そのあたりの内容も大変勉強になりました。",
   post_book_title: "Python クローリング＆スクレイピング",
   post_book_author: "加藤耕太",
   post_book_image_id: nil
   },
   {
   user_id: 12,
   genre_id: 1,
   title: "海外の小説・ノンフィクションに関するご紹介",
   content: "村上春樹氏は、翻訳家としても著名であるが、これまでに翻訳された数々の作品に関して紹介されている。
   中でも、アメリカで死刑制度が復活するきっかけとなった事件に関して、実行犯の実弟が経緯を述べた「心臓を貫かれて」
   は、大変興味深い作品であった。また、そのほかにもティム・オブライエンやトルーマン・カポーティなどの作品にも、
   この本を通して出会うことができた。これから海外の作品も読んでみたいという方にぜい勧めたい作品である。",
   post_book_title: "村上春樹 翻訳ほとんど全仕事",
   post_book_author: "村上春樹",
   post_book_image_id: nil
   },
   {
   user_id: 3,
   genre_id: 3,
   title: "実際にフェルミ推定が勉強できます",
   content: "就活時に興味があり購入。実際にフェルミ推定を実践しながら勉強できる点が面白かったです。
   日本の温泉旅館の数を推定したり、羽田空港の利用者数を増やすための案を考えたりするなど、
   実データなしで論理的に仮説を立てながら推定していく方法を知ることができるので、就活に関係なくおすすめです。",
   post_book_title: "過去問で鍛える地頭力",
   post_book_author: "大石哲之",
   post_book_image_id: nil
   },
   {
   user_id: 7,
   genre_id: 12,
   title: "いわゆるできるサラリーマンの考え方",
   content: "社会人1年目の時に読みました。仕事に取り組む姿勢からスーツの選び方まで、いわゆるできる
   サラリーマンの考え方を勉強できる本でした。これを実践できれば確かに社内での評価は向上すると思いますし、
   実際にできている同期もいました。本当にサラリーマンとしての心得というか王道の生き方が記載されていると思いますし、
   一年目に限らずあらゆる年次の方が読んでも価値があると思います。",
   post_book_title: "入社1年目の教科書",
   post_book_author: "岩瀬大輔",
   post_book_image_id: nil
   },
   {
   user_id: 9,
   genre_id: 1,
   title: "いじめられる側の心情といじめる側の心情",
   content: "個人的な考え方として、いじめは絶対によくないと思いますし、止めるためには
   学校の先生や親が強制的に介入して止めることが必要だと思ってきました。ただ、この小説を読んでいると、
   いじめられる側がいじめる側の生徒にどうしていじめるのか詰め寄るシーンがあるのですが、いじめる側は
   何にも悪びれず「ただ楽しいからしているだけだ」と開き直っています。今まで、善悪の区別がつかない子どものやることだから
   いじめには大人が介入すべきだと考えていましたが、楽しいからしているだけだと開き直れる子どもに、どのような教育ができるでしょうか。",
   post_book_title: "ヘブン",
   post_book_author: "川上未映子",
   post_book_image_id: nil
   },
   {
   user_id: 11,
   genre_id: 16,
   title: "旅行記ってこんなに面白いんだ",
   content: "村上春樹さんが、ギリシャとイタリアに滞在していた時の話です。ともかくめちゃくちゃ面白いです。
   それぞれ旅行中にあった出来事を、同志の独特の価値観と切り口で述べられています。特にギリシャ料理に関する
   記述は秀逸で、この本を読んでからすぐにギリシャ料理店を予約しました。今まで旅行記は読んだことがなかったのですが、
   本を通して実際に自分が旅行している気分になることができました。",
   post_book_title: "遠い太鼓",
   post_book_author: "村上春樹",
   post_book_image_id: nil
   }
 ]
)