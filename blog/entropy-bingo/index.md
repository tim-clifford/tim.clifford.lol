---
title: "Entropy Bingo"
excerpt: "Let me introduce you to a little game I like to call Entropy Bingo."
createdAt: "2023-01-01"
---

Let me introduce you to a little game I like to call Entropy Bingo.

Choose an action that you might take with expectations of anonymity, and try to
figure out whether a determined attacker can figure out who you are, by
counting up the bits of Shannon entropy they can determine. If it reaches 33
bits (corresponding to the >8 billion people on the planet), you lose, and you
have been deanonymised. If not, you win. For simplicity, we assume each piece
of information is uncorrelated with the others. This isn't really true, but
it's napkin maths anyway.

*Disclaimer 1: I should point out that I do not claim to be an expert on
anonymisation and deanonymisation, though it is a fascination of mine. Make
your own decisions, and consider my suggestions carefully. Maybe one day I will
be an expert, if that happens I'll remove this disclaimer :)*

## Example 1: convenience store

Here's an example: I go to my local convenience store and buy an item.
I don't take my phone or any other tracking device, and I pay in cash. Am I
anonymous?

Firstly, my adversary can narrow it down to the number of people who might buy
food at this particular store. Some very approximate maths suggests that this
already knocks off about 20 bits of entropy, but it would be more if my store
were very small. Fun.

I'm the type of person to pay in cash, which knocks off at least another 3
bits, based on statistics about people's payment preferences. If my adversary
has ever deanonymised me before, they will likely know I pay in cash.

Most convenience stores have CCTV, so lets say my adversary can see my face
and what I'm buying. If I lived in China or New York[^nyc] or any other place
that uses facial recognition without consent, I would already have lost. But
let's continue anyway.

[^nyc]: [Horrifyingly, here's one example](https://www.nytimes.com/2022/12/22/nyregion/madison-square-garden-facial-recognition.html)

So, how many bits does my physical appearance count for? The gender I present
knocks off about 1 bit. I wear glasses, which knocks off about another bit. My
hair type knocks off about 3 bits. My approximate age knocks off about 3 more
bits.

That's already 31/33 bits and I definitely haven't thought of everything.
That's seriously bad. Someone who reasonably might have all that information
can immediately narrow me down to one of 4 people.

Who would have all that information? Well, let's say the convenience store is
storing all this video data in "the cloud", which probably means one of
Google's servers. And all of that information about my characteristics and
location? Google has that too. So, yes, even if I don't take a phone and even
if I pay in cash, Google could deanonymise me. Would they? I don't know. But
they certainly have incentive to.

## Example 2: a clandestine deal

Ok, so you're super paranoid and you think you're smart. You go onto the
anonymous web (a Tor onion site), and find someone who lives in your city of
100,000 people who has the thing you want. You make sure they use Matrix,
because you know it's reasonably secure and private, and you make a new Matrix
handle to talk to them. You meet them in person in a random place in the city
to make the exchange, pay in cash, and wear clothes you never usually wear -
plus a cap and balaclava.

*Busted!* You've still given away too much information. What!!!??? Here's the
breakdown:

- Approximate location: 16 bits
- Use of Tor: at least 6 bits
- Use of Matrix: 7 bits
- Height: 2 bits
- Approximate gender and age: 3 bits

**Total: 34 bits**

You made a few mistakes. The biggest was using Matrix. *What??* you cry? But
Matrix is secure! It's private! It's FOSS and it has end-to-end encryption!!

Yes. But privacy is not anonymity. Security is not anonymity. For anonymity,
you need security and plausible deniability. For any given action, there must
be a large number of people who could be responsible for it. You could have a
perfectly private and secure system, but if there are only two users, every
action must have been made by one of those two users. Tor and Matrix are only
successful anonymising tools when used extremely carefully.

Still, this example requires much more nuance. Who, specifically, could
deanonymise you? The person you've made a cash deal with might be able to, but
maybe not. The assumptions of this game are critical, and hard to evaluate in
the real world. Does your use of Tor actually reveal 6 bits? Your adversary
won't have a list of everyone who uses Tor, but if you're someone who cares
this much about anonymity, you might have publicly declared that Tor is a great
tool and people should use it, in which case there might be a list you're on.
The same goes for Matrix, although an accurate list of users is probably a lot
easier to come by. Your adversary might not have an accurate list of people in
your city and their age/height/gender either, but a little digging on social
media would go a long way. (The possibility of your adversary being a law
enforcement agent would go a lot further, if your transaction were illegal)

## What should you do?

What would be a better strategy for a truly anonymous purchase? The first thing
to do is to randomise as many choices as you can. When you're looking for
someone to transact with over Tor, find as many as you can, and choose
randomly, with probabilities proportional to the number of customers you think
they have. Don't insist on a messaging system, use whatever they use, provided
that you can use it entirely over Tor without giving up personal information
(e.g., burner email addresses or Facebook accounts are fine if you can do it
without identity verification). Make your search area as broad as possible,
perhaps even take a train into another city and do the transaction there (try
to avoid cameras as you do). Cover as many of your distinguishing features as
you can, but do it in a boring way - don't wear a balaclava, wear a mask, a
beanie, and large sunglasses if it's sunny.

Additionally, you should try to segment the information such that no party has
access to all of it. Don't tell the person you transact with about your
journey, the rain you came through, when you got off work, or anything else. In
fact, it's best if you don't speak, your voice might be distinctive.

Further, false information goes a long way. Put on a convincing wig. Wear fake
glasses if you have perfect eyesight. Put pebbles in your shoes to change your
gait. If you're brave enough to speak, hint that you came from a different city
than you really did. Each bit of false entropy can have serious anonymising
power.[^tao]

[^tao]: [Terence Tao talks about this](https://terrytao.wordpress.com/about/anonymity-and-the-internet/)

## Entropy Bingo card

To conclude, here's a bingo card with some sources of information I thought of
that an attacker might use to remove your entropy. If you get a bingo, they've
probably got you. It's highly approximate, though I've been careful to keep
incompatible or highly correlated sources of information from being in the same
row/column/diagonal, as much as possible.

+----------------------+----------------------------------+----------------------------+----------------------+
|  Travel by bike      |  Nearest cell tower              |  Use of Matrix             |  Travel by train     |
|                      |                                  |                            |                      |
|  (~5 bits)           |  (~19 bits)                      |  (6 to 8 bits)             |  (~6 bits)           |
+----------------------+----------------------------------+----------------------------+----------------------+
|  IP address          |  Specific Job title              |  Age, gender, height       |  Use of Linux        |
|                      |                                  |                            |                      |
|  (20 to 30 bits)     |  (~10 bits?)                     |  (5 bits)                  |  (5 to 7 bits)       |
+----------------------+----------------------------------+----------------------------+----------------------+
|  Paying in cash      |  Knowledge of 1 person you know  |  Use of Tor                |  City you're in      |
|                      |                                  |                            |                      |
|  (~3 bits)           |  (20 bits)                       |  (6 to 10 bits)            |  (9 to 12 bits)      |
+----------------------+----------------------------------+----------------------------+----------------------+
| Not carrying a phone |  Simple facial features          |  Town you're in            |  Uncommon hobby      |
|                      |                                  |                            |                      |
|  (3 to 5 bits)       |  (4 to 6 bits)                   |  (16 to 20)                |  (8 to 10 bits)      |
+----------------------+----------------------------------+----------------------------+----------------------+

Ironically, many of the things on the bingo board, like Matrix, Tor, and Linux,
are things which protect your privacy. But because not enough people use them,
knowledge that you're using them provides a fair bit of deanonymisation power.
The solution: get more people to use them, to protect those that need
anonymity.

*Disclaimer 2: I think I need to say that my fascination with anonymity doesn't
stem from a propensity to perform illegal acts. Though, I would probably say
that even if it weren't true. Regardless, I've gotta already be on some
watchlists, right? Hello there NSA agent. Think about your life choices. Be
more like Snowden.*
