ゲーム概要
・プレイヤーキャラクターは1体のみで操作する。
・敵は複数の種類が存在し、各々攻撃方法やHPが異なります。
・プレイヤーはアイテムを取得することができ、必殺技を任意のタイミングで使用可能です。
・HPが0になるとゲームオーバーとなり、プレイヤーは再挑戦が必要です。
・ゲームの目的は25体の敵を倒すことで、倒すスピードによってタイムを競う要素も含まれています。

工夫点

１．敵キャラクターの種類と攻撃方法

・さまざまな種類の敵を設定し、それぞれの攻撃方法やHPを変えることで、戦略性を高めています。プレイヤーは 敵ごとに異なるアプローチを取る必要があり、ゲームに深みが増します。

2.アイテム取得と必殺技

・アイテムを取得することでプレイヤーの能力が強化され、必殺技をタイミングよく使うことで戦闘を有利に進めることができます。これにより、プレイヤーが戦略的にプレイする楽しさを感じることができます。

3.タイムアタック要素

25体の敵を倒すスピードを競う要素があることで、ゲームのリプレイ性が高まり、プレイヤーが何度も挑戦する意欲を引き出します。

改善点
1.難易度調整

敵の種類が増えると、戦闘が複雑になり、特に初心者には難しく感じられるかもしれません。レベルごとに敵の強さを調整し、プレイヤーが段階的に成長を感じることができるようにすると、ゲームがより楽しめるでしょう。
2.プレイヤーのHPやアイテムの管理

プレイヤーのHPが減少する中で必殺技やアイテムをどのタイミングで使うかが重要になりますが、HPの回復方法やアイテムの出現頻度を調整することで、プレイヤーにとってより挑戦的で満足感のあるバランスにできるかもしれません。
3.エフェクトやアニメーションの強化

プレイヤーが必殺技を使った時や敵が攻撃を受けた際に、視覚的に強いエフェクトやアニメーションを加えることで、戦闘に迫力が増し、よりプレイヤーが引き込まれるでしょう。

追加アイデア

・敵AIの強化
敵キャラクターに異なる行動パターンやAIを追加することで、戦闘がさらに戦略的になり、プレイヤーにとっての挑戦が増します。例えば、ある敵は攻撃を避けようと動き回る、ある敵はプレイヤーを囲んで攻撃するなど。

・多彩なプレイヤーのスキルツリー
プレイヤーの成長要素を追加して、倒した敵や達成した目標に応じてスキルポイントを得て、必殺技やアイテムの使い方を強化できるようにすることも面白いでしょう。

実装画面

ホーム画面<br>
コードを実行すると以上のような画面に遷移します。画面左上に操作方法が書かれています。<br>
![スクリーンショット 2025-02-05 234056](https://github.com/user-attachments/assets/55f703c7-529b-491e-9ed5-fc72d9a2f5cb)

ゲーム開始時<br>
ステージの中央部分にプレイヤーが配置され、現時点でのステージ上にいる敵キャラクター数や経過時間が表示されています。<br>

![スクリーンショット 2025-02-05 234259](https://github.com/user-attachments/assets/2d02bd36-2d67-4d5b-b724-88d077abfdb8)

攻撃時<br>
攻撃したとき、攻撃するアニメーションが動作します。また敵の上に書かれている数字は敵のHPであり、これが0になると敵キャラクターが消滅する。<br>
![スクリーンショット 2025-02-05 234316](https://github.com/user-attachments/assets/05d40577-7ea5-45b9-a77a-1cbee7ebf8b5)

必殺技使用時<br>
画面右下に、炎のアイコンが表示されたら必殺技を発動することができます。必殺技を発動したとき敵全体に20ダメージを与えることができます。<br>
![スクリーンショット 2025-02-05 234606](https://github.com/user-attachments/assets/0df94959-c583-4637-a755-fccace36e33f)

回復使用時<br>
画面右下に緑のポーションアイコンが表示されたら、プレイヤーはHPを回復させることができます。<br>
![スクリーンショット 2025-02-05 234624](https://github.com/user-attachments/assets/6b7f72e8-2b7d-4be0-8b43-326d023fbc61)

ゲームオーバー時<br>
プレイヤーのHPが0になったとき、ゲームオーバーと画面に表示されます。<br>
![スクリーンショット 2025-02-05 234355](https://github.com/user-attachments/assets/798d7691-7fd9-4971-aeb5-6522ff2f31bc)

ゲームクリア時<br>
敵を25体倒したとき、ゲームクリア画面に遷移し、クリアタイムとこれまでのクリアタイムの最速時間が表示されます。<br>
![スクリーンショット 2025-02-05 234525](https://github.com/user-attachments/assets/f7451f78-7d31-43ae-b5ea-9d1d3f7a68c6)


