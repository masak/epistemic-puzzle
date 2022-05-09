> We pick two numbers `a` and `b`, so that `a ≥ b` and both numbers are within
> the range `[2, 99]`. We give Mr.P the product `a*b` and give Mr.S the sum
> `a+b`.
> 
> The following dialog takes place:
> 
>     Mr.P: I don't know the numbers
>     Mr.S: I knew you didn't know. I don't know either.
>     Mr.P: Now I know the numbers
>     Mr.S: Now I know them too
> 
> Can we find the numbers a and b?

I found this puzzle (which I had heard somewhere before, and found totally
impossible):

http://okmij.org/ftp/Algorithms.html#mr-s-p

The solution in Haskell was surprisingly readable! It's a cute trick to encode
facts as functions. I thought it'd be a fun exercise to translate it to
idiomatic Python.

It was!

In my opinion the Haskell solution still wins slightly in elegance, but not by
all that much.

I also wrote a version in Perl. Still want to do one in Bel! ☺

## Another one!

[This](https://alexanderell.is/posts/numbers-game/) looks like a fun variant.

> Two numbers are chosen randomly, both are positive integers smaller than 100.
> Sandy is told the sum of the numbers, while Peter is told the product of the numbers.
>
> Then, this dialog occurs between Sandy and Peter:
>
> Peter: I don’t know the numbers.
> Sandy: I don’t know the numbers.
> Peter: I don’t know the numbers.
> Sandy: I don’t know the numbers.
> Peter: I don’t know the numbers.
> Sandy: I don’t know the numbers.
> Peter: I don’t know the numbers.
> Sandy: I don’t know the numbers.
> Peter: I don’t know the numbers.
> Sandy: I don’t know the numbers.
> Peter: I don’t know the numbers.
> Sandy: I don’t know the numbers.
> Peter: I don’t know the numbers.
> Sandy: I don’t know the numbers.
>
> Peter: I do know the numbers.
>
> What are the numbers?

[HN discussion](https://news.ycombinator.com/item?id=31308423).
