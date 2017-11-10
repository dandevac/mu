# Example program showing 'return-continuation-until-mark' return other values
# alongside continuations.
#
# Print out a given list of numbers.
#
# Expected output:
#   1
#   2
#   3

def main [
  local-scope
  l:&:list:num <- copy 0
  l <- push 3, l
  l <- push 2, l
  l <- push 1, l
  k:continuation, x:num, done?:bool <- call-with-continuation-mark create-yielder, l
  {
    break-if done?
    $print x 10/newline
    k, x:num, done?:bool <- call k
    loop
  }
]

def create-yielder l:&:list:num -> n:num, done?:bool [
  local-scope
  load-ingredients
  {
    done? <- equal l, 0
    break-if done?
    n <- first l
    l <- rest l
    return-continuation-until-mark n, done?
    loop
  }
  # A function that returns continuations shouldn't get the opportunity to
  # return. Calling functions should stop calling its continuation after this
  # point.
  return-continuation-until-mark -1, done?
  assert 0/false, [called too many times, ran out of continuations to return]
]