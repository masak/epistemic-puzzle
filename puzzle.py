# Solving the "Mr.S and Mr.P" puzzle by John McCarthy:
# 
# 	Formalization of two Puzzles Involving Knowledge
# 	McCarthy, John (1987).
# 	http://www-formal.stanford.edu/jmc/puzzles.html

# We pick two numbers a and b, so that a>=b and both numbers are within
# the range [2,99]. We give Mr.P the product a*b and give Mr.S the sum
# a+b.

# The following dialog takes place:
# 
# 	Mr.P: I don't know the numbers
# 	Mr.S: I knew you didn't know. I don't know either.
# 	Mr.P: Now I know the numbers
# 	Mr.S: Now I know them too
# 
# Can we find the numbers a and b?


# The following is Python code, interspersed with comments.
# It takes a while to compute; the optimizations are
# straightforward; yet we deliberately chose the simplest code.
# 
# Chung-chieh Shan has pointed out the paper
#    Hans P. van Ditmarsch, Ji Ruan and Rineke Verbrugge
#    Sum and Product in Dynamic Epistemic Logic
#    Journal of Logic and Computation, 2008, v18, N4, pp.563--588.
# 
# that discusses at great extent the history of the riddle, its
# modeling in modal `public announcement logic', and solving using
# epistemic model checkers.

from collections import defaultdict

# First, let's define good numbers

good_nums = range(2, 100)   # 2 inclusive, 100 exclusive

# Given a number p, find all good factors a and b (a>=b)
# and return them (the pairs of them) in a list. We use the obvious and
# straightforward memoization (tabling):

def group_by(fn):
    result = defaultdict(list)
    for a in good_nums:
        for b in good_nums:
            if a >= b:
                n = fn(a, b)
                result[n].append( (a, b) )
    return result

good_factors_dict = group_by(lambda a, b: a * b)

def good_factors(p):
    return good_factors_dict[p]

# Given a number s, find all good summands a and b (a>=b)
# and return the pairs of them in a list

good_summands_dict = group_by(lambda a, b: a + b)

def good_summands(s):
    return good_summands_dict[s]


def is_singleton(it):
    """Test if a list is a singleton"""
    return len(list(it)) == 1

# Let's encode the first fact: Mr.P doesn't know the numbers.
# Mr. P would have known the numbers if the product had had a unique good
# factorization

def fact1(a, b):
    return not is_singleton(good_factors(a * b))

# Let's encode the second fact: Mr.S doesn't know the numbers

def fact2(a, b):
    return not is_singleton(good_summands(a + b))

# Let's encode the third fact: Mr.S knows that Mr.P doesn't know the numbers.
# In other words, for all possible summands that make a+b, Mr.P cannot be
# certain of the numbers

def fact3(a, b):
    return all(fact1(aa, bb) for aa, bb in good_summands(a + b))

# Let's encode the fourth fact: Mr.P _now_ knows that fact3 is true
# and is able to find the numbers. That is, of all factorizations
# of a*b there exists only one that makes fact3 being true.

def fact4(a, b):
    return is_singleton((aa, bb) for aa, bb in good_factors(a * b) if fact3(aa, bb))

# The fifth fact is that Mr.S. knows that Mr.P found the numbers:
# of all the possible decompositions of a+b, there exists only one that
# makes fact4 true.

def fact5(a, b):
    return is_singleton((aa, bb) for aa, bb in good_summands(a + b) if fact4(aa, bb))

# Finally, we compute the list of all numbers such that fact1..fact5
# hold:

result = [(a, b) for a in good_nums for b in good_nums if a >= b and
        all(fact(a, b) for fact in [fact1, fact2, fact3, fact4, fact5])]

# The answer is
# >>> result
# [(13, 4)]

# That is, a unique answer. Note how Python notation is relatively concise,
# compared to the one employed in the paper by McCarthy.

