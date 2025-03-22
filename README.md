# SimpleThread Code Challenge

Hail SimpleThread! 

I had a blast working on this coding challenge. What sounded straightforward at first, turned out to have some really interesting puzzles to solve around overlapping projects, different city types, and varying reimbursement rates.

I thought I had all my edge cases covered after my initial planning, but implementation had some surprises in store! One of the trickiest parts was handling projects that butted right up against each other - you know, when one project ends on the 5th and another starts on the 6th. Should that count as continuous? What about the travel day calculations? It led to some frustrating, but illuminating, false paths that lead to failure of my date handling and sequence detection. But thanks to a solid set of test cases to work against (thank you for that) they eventually fell into place once we identified BOTH edges, date and rate, properly. I left some comments on the `ReimbursementCalculator#find_sequences` method to cover those. 

### The Rules 

Here's what we needed to figure out:
- Each day only gets reimbursed once (even if an inspector is juggling multiple projects)
- Projects that run together form a sequence and get treated as one big project
- First and last days of any sequence are "travel" days
- Days in the middle are "full" days
- If there's a gap between projects, we start a new sequence
- When projects overlap in different city types, pay out the high-cost city.

### Travel Rates

| Day Type | City Type | Rate |
|----------|-----------|------|
| Travel   | Low Cost  | $45  |
| Travel   | High Cost | $55  |
| Full     | Low Cost  | $75  |
| Full     | High Cost | $85  |


## The Result/Solution

We tested this against all four provided example scenarios:

| Scenario | Project Details | Result |
|----------|----------------|---------|
| 1 | Project 1: Low Cost City, 10/1/24 to 10/4/24 | **$240** |
| 2 | Project 1: Low Cost City, 10/1/24 to 10/1/24<br>Project 2: High Cost City, 10/2/24 to 10/6/24<br>Project 3: Low Cost City, 10/6/24 to 10/9/24 | **$665** |
| 3 | Project 1: Low Cost City, 9/30/24 to 10/3/24<br>Project 2: High Cost City, 10/5/24 to 10/7/24<br>Project 3: High Cost City, 10/8/24 to 10/8/24 | **$490** |
| 4 | Project 1: Low Cost City, 10/1/24 to 10/1/24<br>Project 2: Low Cost City, 10/1/24 to 10/1/24<br>Project 3: High Cost City, 10/2/24 to 10/3/24<br>Project 4: High Cost City, 10/2/24 to 10/6/24 | **$440** |

## Try It Out

1. Grab the code: `git clone`
2. Get the deps: `bundle install`
3. Run the tests: `bundle exec rspec`
4. See it in action: `ruby reimbursement_calculator.rb`

## Requirements

- Ruby 2.7+ 
- RSpec for testing 