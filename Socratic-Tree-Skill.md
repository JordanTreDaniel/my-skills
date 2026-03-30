/create-skill 

i need to separate the socratic thinking and improve it. 
Find all the ways to break something into trees. 
that mainly consists of two skills: going from parent to child, or child to parent. 
Most rules i would make about how to go from one to the other would be true in reverse as well so if you are going from parent to children, then you would be asking yourself what are the parts of this? What are the instances of this? 

i have examples of the types of links that would constitue a parent-child relationship. 
The impelementation is also two-way. 
the socratic skill could help improve our auto-ingestion in the trees app(s) and the socratic method, now being broken into a separate skill for thinking, can learn from the stuff we have done in the trees app(s). 
(mainly the types of links). 
The socratic-powered ai approach may be deserving of its own benchmark test, but we will just focus on the skill for now. 
the purpose of this skill is everything really. 
it helps to code better, it helps to organize context, trim context, focus on tasks, communicate at just the right level (as opposed to having to choose between detailed llm-braindump, and hoping the llm agrees with you about what "concise" means) @my-skills/skills/route-knowledge/ - take that skill and extract (dont edit this skill, just create new) with the socratic process abstracted, zoomed out, more comprehensive. 
come back with questions to help me develop it. 
The goal of the skill is to be able to take in any amount of context from text or from llm agent convo, which would include actions, context, etc. 
and then, using an intention of the user as the basis and lense, be able to output a "tree" of info (will just be something that can indicate heirarchy with text, like using markdown elements, or just nested lists, etc.. 
the markdown works like, if we have an h1, then some text, then some h2's, and some text, we have a tree like h1 (plus text desc) > h2, h2, h2 > ... 
 so the h2s are the child of the h1, until another h1 comes to "reset" the "gps". 
The gps tells us where we are in the tree. 

We are trying to use socratic thinking to get the shape of the knowledge, so that we can:
- present the info better (the trees apps attempt this with visuals, this will be llm skill, so text-only)
- Understand the info better (if you cant put it simply, aka dont know the root of what you are saying, then you dont understand it)
- understand the links of the info - Always the most important part. Brain is nothing without neural networks. This forces us, and guides us through drawing out a map.
- be exact in listening and responding. Its much easier to know what im saying, and how it applies to what you know, and what we have talked about, and what you dont know, etc, if you already have a tree drawn out.
- makes analysis better. thinking of the types of links between info is a superpower that allows 10x analysis, bc we clear our brain (or the llm's)
- Makes llm summarization better. current day summarizers do various things, from crude (fixed length chopping), to principle-guided, but still clumsy, (begin-middle-end), but they all miss the point: real summarization is simply taking the root of the tree, and then walking down until the details no longer matter for the subject at hand
- Allows llms to focus. its like the research paper that came out recently, and put llms in a loop recursively to read info. so the info/context is not all loaded into every "thought" that the llm has, but rather the llm is able to cut the context, then use a sub-agent to examine that part. The problem with this approach is token costs (even though it helps with token costs vs traditional context-stuffing) and subjectivity, and lack of traceability. The llm also trusts that the info is organized and presented well.