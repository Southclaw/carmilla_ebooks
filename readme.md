# Carmilla transcript markov chain

Huge thanks to [Rachel](http://transcribingcarmilla.tumblr.com/episodes) for creating the original transcripts!

This Ruby script builds a simple markov chain from the Carmilla season 1 transcripts which are then used to generate hilarious sentences!

# I'm sorry, what?

Here's a quick non-tech rundown of how on earth a "markov chain" works:

Let's take an extract from episode four as an example:

> "See? Blood. In the milk container. In my creepy roommate's milk container. So, she's gotta go, right?"

Now let's make a bi-gram! (no, that's not the term for your experimental grandmother)

```python
['See', 'Blood']
['Blood', 'In']
['In', 'the']
['the', 'milk']
['milk', 'container']
['container', 'In']
['In', 'my']
['my', 'creepy']
['creepy', 'roommate']
["roommate's", 'milk']
['milk', 'container']
['container', 'So']
['So', 'she']
["she's", 'gotta']
['gotta', 'go']
['go', 'right']
```

Can you see the pattern? A bi-gram is a list of sets of two words which appear next to each other. You look at the first word and the word to the right and note it down, then move _one_ word to the right and repeat!

In this bi-gram, we have some repeating words: "milk" and "container". Let's count up which words appear after these words:

```python
'milk': {'container': 2},
'container': {'in': 1, 'so': 1},
```

So "milk" is followed by "container" twice, "container" is followed by "in" and "so" (ignoring ends of sentences).

This means that two possible combinations of these words could exist:

> "milk container in"
> "milk container so"

Poetic, right?

Okay, maybe not with a single sentence but run this same algorithm over the entire transcript and you get things like:

> "[Laura dials number] Come, join the fun. So youre just miserable and alone."

and

> "And chocolate is comforting in the amazon that makes ants climb up trees before it kills them."

oh, and

> "A wretched, crawling thing like this insane plan that the actually useful thing to do about the past two weeks, you've broken into the bathroom, Thanks."

Of course I overlooked a lot of things since this was meant to be a very simple look at this type of text analysis.

One of the main things I skipped out was scoring the words. In this example, I've run the code over episode thirty:

```python
'so': {'close': 1,
        'fast': 1,
        'maybe': 3,
        'much': 1,
        'uh': 2,
        'we': 2,
        'what': 1},
```

And we can see here that the word "so" is followed by quite a few different words throughout the episode. The numbers on the right are counters so we can see that "so" is followed by "maybe" 3 times making it the most likely word to follow "so".

Once a larger dictionary of words is built in this way, the sentences generated can start to make a bit more sense since the sentence generation is based on a weighted selection which uses that number as a score to help it pick the next word when generating a sentence.

Another thing I left until the end here is tokenisation. Tokenisation is the process of splitting a pile of text into words which can be individually dealt with however you like. This may seem like an easy job but it can get awkward once you start introducing more complex linguistic features (not forgetting that the English language is full of annoying exceptions to simple rules!)

Another thing about processing transcripts like this is that they contain [stage directions] and character line markers ("CARMILLA:" etc). This often results in awkward looking sentences like:

> "youve broken into the bathroom] Thanks."

Which was the actual output from the program which I then corrected for earlier example. The parser that I used obviously didn't understand how [square brackets] work so it ends up placing single open [ or close ] brackets in seemingly random places which make little sense. I wanted to keep the stage directions in because it can result in some funny phrases:

> "[Laura dials number] Come, join the fun."

So I will probably work on improving this tokenisation in the future.


I hope you found this somewhat interesting, tweet me @SouthclawJK for questions, text analysis or just general chatting about creating robots that chat nonsense!
