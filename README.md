# Enhancing The Quality Start

## Introduction

I'd like to start off by asking you a trivia question:  

Who pitched better in 2015? Shelby Miller or Drew Hutchison?  

![](miller.jpg) ![](hutch.jpg)

Here's a hint. Their records were 6-17 and 13-5, respectively.  

I'm guessing that with this information you would be comfortable answering Drew Hutchison.  

Here's another hint. Their ERAs were 3.02 and 5.57, respectively.  

Wait... What?! I'm guessing now you may be reconsidering.  

Here's my point.  

The notion that wins are sufficient to measure starting pitcher performance would be absurd in today's game. First and foremost, it's a statistic that's heavily dependent on run support. Let's take a closer look at our Miller-Hutch example. Shelby Miller played with the Atlanta Braves and only tallied 6 wins in 33 starts because he only received 2.54 RS/9 (run support per 9 innings) from the league's *worst* offense. Meanwhile, Drew Hutchison played with the Toronto Blue Jays and tallied 13 wins in 28 starts behind 7.90 RS/9 from the league's *top* offense.  

In case you missed it, the answer to the trivia question was Shelby Miller. He was an All-Star in 2015.  

With the exception of pitchers like Madison Bumgarner or Shohei Ohtani, whose presence can be felt at the plate as well as the rubber, run support isn't something a pitcher can really control, so why do we put so much emphasis on wins? Clearly, wins are the currency of the game; winning the World Series is what it's all about, but solely using wins to evaluate pitching *performance* is not the way to go. As you could see from the Miller-Hutch example, there are other statistics we can use to compare them. It's safe to say ERA is the "go-to" ratio statistic, but if you're hard-set on using a counting statistic, I'd suggest looking at the Quality Start. In our Miller-Hutch example we'd find that Miller accumulated 21 QS (64% conversion rate) to Hutchison's 9 QS (32% conversion rate), further evidence that Miller had the better 2015.  

Now... the Quality Start is far from a perfect statistic. You can't even use it as a sortable option in Fangraphs! The criteria are simple: (1) pitch at least 6 innings and (2) allow no more than 3 earned runs. However, these simple criteria don't capture every *quality* performance, so just as the title indicates, I decided to give the Quality Start an enhancement.  

## Methodology

I've looked at many statistics that measure pitching performance, and I've noticed that very few incorporate run expectancy. One statistic that does is RE24 (Run Expectancy based on 24 base-out states) for both hitters and pitchers, but why not use run expectancy to create a new set of criteria for the Quality Start?

> Rather than award a pitcher a Quality Start for pitching at least 6 innings while allowing 3 earned runs or less, a *quality* start should be awarded if the pitcher performs better than the league average, i.e. you should expect a lead at the end of the inning in which the starter leaves the game.

This can easily be represented with the following formula:

`PPS = (LARA * IP) - (RA + ERC)`

where `PPS` stands for "Pitching Performance Score", `LARA` is the league-average runs allowed per inning, `IP` is the innings pitched (rounding up if the starter can't finish an inning), `RA` is the runs the starter has allowed *the moment he leaves the game*, and `ERC` is the expected number of runs we charge the starter if he can't finish the inning. By definition, the PPS is the difference between the number of runs a league average pitcher would allow in the same number of innings and the expected number of runs the starter allows. Essentially, it's the number of runs you can expect to be leading by (or trailing by if `PPS` is negative) at the end of the inning in which the starter leaves the game.

I say "expected number of runs the starter allows" to address one of the issues with the current Quality Start statistic. Right now, it is entirely possible for a starter to be in line for a Quality Start and have that taken away from him **without ever throwing a pitch**. This can happen when he leaves the game with runners still on base. Whenever the starter leaves with runners on base, his pitching line is still in jeopardy. If the reliever allows the inherited runners to score, the starter gets charged. Thus, one of my enhancements is taking the bullpen completely out of the equation. Instead, whenever the starter leaves the game with runners still on base, he is charged for the number of runs we would expect to score in the remainder of the inning (`ERC`). This `ERC` can easily be found using a Runs Expectancy Matrix.

### Runs Expectancy Matrix

If you're already familiar with the Runs Expectancy Matrix, feel free to skip this section, but I think some you are unfamiliar with this concept, so I'll talk more about it.

The Runs Expectancy Matrix is a useful sabermetric tool that tells us the number of runs we would expect to be scored in the remainder of an inning for each of the 24 possible base-out states.

What's a base-out state?

A base-out state is a combination of the base occupancy and the number of outs at the beginning of each play. There are 8 different ways the bases can be occupied and there are 3 different out situations, so 8 x 3 = 24 base-out states. These 24 base-out states are the framework of the Runs Expectancy Matrix, as seen in the table below.

|          | **0 Out**  | **1 Out** | **2 Out**
:---------:|:----------:|:---------:|:----------:
 **- - -** |            |           |
 **- - 1** |            |           |
 **- 2 -** |            |           |
 **- 2 1** |            |           |
 **3 - -** |            |           |
 **3 - 1** |            |           |
 **3 2 -** |            |           |
 **3 2 1** |            |           |

Just to make sure you fully understand this concept, let's run through a quick example on how a Runs Expectancy Matrix is built. We'll run through a hypothetical half-inning and develop a corresponding Runs Expectancy Matrix.

Every inning starts the same way: 'bases empty, 0 out', so we'll set up a counter in this state. The counter (denoted R) will keep track of every run scored for the remainder of the inning.

|          | **0 Out**  | **1 Out** | **2 Out**
:---------:|:----------:|:---------:|:----------:
 **- - -** |  **R = 0** |           |
 **- - 1** |            |           |
 **- 2 -** |            |           |
 **- 2 1** |            |           |
 **3 - -** |            |           |
 **3 - 1** |            |           |
 **3 2 -** |            |           |
 **3 2 1** |            |           |
 
Suppose the inning begins with a lead-off single. The base-out state changes to 'man on 1st, 0 out', so we'll add counter to this new state.

|          | **0 Out**  | **1 Out** | **2 Out**
:---------:|:----------:|:---------:|:----------:
 **- - -** |  R = 0     |           |
 **- - 1** |  **R = 0** |           |
 **- 2 -** |            |           |
 **- 2 1** |            |           |
 **3 - -** |            |           |
 **3 - 1** |            |           |
 **3 2 -** |            |           |
 **3 2 1** |            |           |
 
Similarly, if the next batter strikes out, we transition to the 'man on 1st, 1 out' state and set up another counter.

|          | **0 Out**  | **1 Out** | **2 Out**
:---------:|:----------:|:---------:|:----------:
 **- - -** |  R = 0     |           |
 **- - 1** |  R = 0     |  **R = 0**|
 **- 2 -** |            |           |
 **- 2 1** |            |           |
 **3 - -** |            |           |
 **3 - 1** |            |           |
 **3 2 -** |            |           |
 **3 2 1** |            |           |

With a man on 1st and one out, the third batter blasts a 2-run homerun. The base-out state transitions to 'bases empty, 1 out', but more importantly, 2 runs scored in the process. Thus, for *each* of the previous counters we add 2 runs to the total. Note that we do not add 2 runs to the newly added counter.

|          | **0 Out**  | **1 Out** | **2 Out**
:---------:|:----------:|:---------:|:----------:
 **- - -** |  R = **2**     |  **R = 0**    |
 **- - 1** |  R = **2**     |  R = **2**    |
 **- 2 -** |            |           |
 **- 2 1** |            |           |
 **3 - -** |            |           |
 **3 - 1** |            |           |
 **3 2 -** |            |           |
 **3 2 1** |            |           |
 
Suppose the fourth batter hits another homerun. Back to back, baby! As a result, we stay in the 'bases empty, 1 out' state and add another run. We set up a second counter in the same state and increment the other counters.

|          | **0 Out**  | **1 Out**     | **2 Out**
:---------:|:----------:|:-------------:|:----------:
 **- - -** |  R = **3**     |  R = **1**, **R = 0** |
 **- - 1** |  R = **3**     |  R = **3**        |
 **- 2 -** |            |               |
 **- 2 1** |            |               |
 **3 - -** |            |               |
 **3 - 1** |            |               |
 **3 2 -** |            |               |
 **3 2 1** |            |               |
 
Similarly, if the fifth batter hits a single, the base-out state transitions to 'man on 1st, 1 out' and we add a second counter to that state.

|          | **0 Out**  | **1 Out**     | **2 Out**
:---------:|:----------:|:-------------:|:----------:
 **- - -** |  R = 3     |  R = 1, R = 0 |
 **- - 1** |  R = 3     |  R = 3, **R = 0** |
 **- 2 -** |            |               |
 **- 2 1** |            |               |
 **3 - -** |            |               |
 **3 - 1** |            |               |
 **3 2 -** |            |               |
 **3 2 1** |            |               |
 
No matter how complicated the inning may be, the procedure stays the same. After every play we add a counter to the respective base-out state (even if there is a counter already there) and increment all previous counters by the runs scored on the play. Each counter keeps track of the runs scored until the third out is made. Suppose the inning continues as follows:

ground-rule double,

|          | **0 Out**  | **1 Out**     | **2 Out**
:---------:|:----------:|:-------------:|:----------:
 **- - -** |  R = 3     |  R = 1, R = 0 |
 **- - 1** |  R = 3     |  R = 3, R = 0 |
 **- 2 -** |            |               |
 **- 2 1** |            |               |
 **3 - -** |            |               |
 **3 - 1** |            |               |
 **3 2 -** |            |  **R = 0**    |
 **3 2 1** |            |               |
 
sacrifice flyout, runner on 3rd scores,
 
|          | **0 Out**  | **1 Out**     | **2 Out**
:---------:|:----------:|:-------------:|:----------:
 **- - -** |  R = **4**     |  R = **2**, R = **1** |
 **- - 1** |  R = **4**     |  R = **4**, R = **1** |
 **- 2 -** |            |               |  **R = 0**
 **- 2 1** |            |               |
 **3 - -** |            |               |
 **3 - 1** |            |               |
 **3 2 -** |            |  R = **1**    |
 **3 2 1** |            |               |
 
and a strikeout to end the inning.

|          | **0 Out**  | **1 Out**     | **2 Out**
:---------:|:----------:|:-------------:|:----------:
 **- - -** |  R = 4     |  R = 2, R = 1 |
 **- - 1** |  R = 4     |  R = 4, R = 1 |
 **- 2 -** |            |               |  R = 0
 **- 2 1** |            |               |
 **3 - -** |            |               |
 **3 - 1** |            |               |
 **3 2 -** |            |  R = 1        |
 **3 2 1** |            |               |

...

|          | **0 Out**    | **1 Out**    | **2 Out**
:---------:|:------------:|:------------:|:------------:
 **- - -** | N = 1, T = 4 | N = 2, T = 3 |
 **- - 1** | N = 1, T = 4 | N = 2, T = 5 |
 **- 2 -** |              |              | N = 1, T = 0
 **- 2 1** |              |              |
 **3 - -** |              |              |
 **3 - 1** |              |              |
 **3 2 -** |              | N = 1, T = 1 |
 **3 2 1** |              |              |
 
 ## Discussion
 
I've just shown that my enhanced Quality Start is a better indicator of pitching performance than its counterpart, but it still doesn't tell the whole story... and my journey didn't end there. I remember compiling the numbers for the 2016 season and finding JA Happ at the top of the leaderboard in eQS. I *had* to tell my friends this odd discovery and they're like, "you're stat is broken".

Yes and no.

It really comes down to your definition of an 'elite' pitcher. I've found that eQS is good at measuring a pitcher's consistency; however, eQS doesn't really capture the dominance of a pitcher, which is how most people distinguish the 'good' from the 'elite'. As long as the PPS is positive, it doesn't matter by how much, the starter receives an eQS. Thus, in order to capture this 'dominance', I chose to look at the starter's Average Pitching Performance Score (APPS) over the course of the full season. This paints a picture much closer to what's already in our heads. Clearly, there are pitchers in the MLB more dominant than JA Happ, and APPS would tell us there are many. Here is a list of the Top 20 Pitchers in 2016 in APPS who had at least 20 starts.

| Starting Pitcher |  GS  |  eQS  |  APPS
:-----------------:|:----:|:-----:|:------:
Clayton Kershaw    |  21  |  18   |  2.105
Kyle Hendricks     |  30  |  24   |  1.399
Jon Lester         |  32  |  24   |  1.356
Johnny Cueto       |  32  |  23   |  1.159
Max Scherzer       |  34  |  25   |  1.089
Noah Syndergaard   |  30  |  19   |  1.056
Justin Verlander   |  34  |  26   |  1.045
Junior Guerra      |  20  |  12   |  1.021
Jose Fernandez     |  29  |  19   |  1.005
Madison Bumgarner  |  34  |  24   |  0.964
Aaron Sanchez      |  30  |  23   |  0.931
Jake Arrieta       |  31  |  18   |  0.923
Tanner Roark       |  33  |  22   |  0.915
Jacob DeGrom       |  24  |  15   |  0.889
Masahiro Tanaka    |  31  |  21   |  0.867
Carlos Martinez    |  31  |  21   |  0.862
Jose Quintana      |  32  |  22   |  0.857
Chris Sale         |  32  |  24   |  0.826
JA Happ            |  32  |  26   |  0.823
Julio Teheran      |  30  |  19   |  0.823

If there's one thing you should take away from this, Clayton Kershaw was a **beast** when he wasn't injured. An APPS of 2.105 basically tells us that by the end of the inning Kershaw left the game, you could expect a 2.105 run lead. Ridiculous!

> The Average Pitching Performance Score (APPS) is the average lead, or deficit, you can expect to have at the end of the inning the starter leaves the game.

Surprisingly, Kershaw's 2016 season didn't even crack the Top Ten in the all-time list dating back to 1925. According to APPS, Pedro Martinez's 2000 season was the most dominant single-season performance in the history of baseball. Yeah, I don't think APPS is broken.

| Starting Pitcher | Year |  GS  |  eQS  |  APPS
:-----------------:|:----:|:----:|:-----:|:------:
Pedro Martinez     | 2000 |  29  |  26   | 2.767
Greg Maddux        | 1994 |  25  |  21   | 2.647
Greg Maddux        | 1995 |  28  |  25   | 2.642
Dwight Gooden      | 1985 |  35  |  30   | 2.341
Jim Turner         | 1937 |  28  |  22   | 2.282
Carl Hubbell       | 1936 |  26  |  21   | 2.217
Roger Clemens      | 1997 |  34  |  27   | 2.204
Lefty Grove        | 1931 |  30  |  25   | 2.194
Kevin Brown        | 1996 |  32  |  27   | 2.192
Hal Schumacher     | 1933 |  27  |  23   | 2.179

