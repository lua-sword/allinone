local foo = require "foo"
print(foo.getx(123) )
print(require"bar")
print(not not sources.foo, not not sources.bar)

package.preload["buz"] = preloadgeneric
print(require"buz")
