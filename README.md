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

I've done a fair amount of research on statistics that measure pitching performance, and I've noticed that very few, if any, incorporate run expectancy. Work has already been done with RE24 (Run Expectancy based on 24 base-out states) for both hitters and pitchers, but why not use run expectancy to create a new set of criteria for the Quality Start?

> Rather than award a pitcher a Quality Start for pitching at least 6 innings while allowing 3 earned runs or less, a *quality* start should be awarded if the pitcher performs better than the league average, i.e. you should expect a lead at the end of the inning in which the starter leaves the game.

This can easily be represented with the following formula:

$$PPS = (X*IP)-(RA+ERC)$$