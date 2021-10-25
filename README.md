 [![cfmlbadges](https://cfmlbadges.monkehworks.com/images/badges/compatibility-coldfusion-2016.svg)](https://cfmlbadges.monkehworks.com) [![cfmlbadges](https://cfmlbadges.monkehworks.com/images/badges/modernize-or-die.svg)](https://cfmlbadges.monkehworks.com)

# cfml-nanoid
CFML implementation of [nanoid](https://github.com/ai/nanoid), secure URL-friendly unique ID generation.

- A tiny, secure URL-friendly unique string ID generator for JavaScript
- Safe. It uses CFML's RandRange("SHA1PRNG") to guarantee a proper distribution of symbols.
- Compact. It uses more symbols than UUID (`A-Za-z0-9_-`) and has the same number of unique options in just 21 symbols instead of 36.

## Usage

Instantiate the component:

```js
nanoId = new nanoId();
```

## nanoId.generate()

Generates compact ID with 21 characters of the alphabet `0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-`

```js
writeOutput(nanoId.generate());
// jLWi7TKamN1zqpE_Z00Ab
```

## nanoId.generate(_alphabet_, _size_)
One-time override for a single ID generation
```js
writeOutput(nanoId.generate(alphabet="ABCDEFGHJKLMNPQRSTUVXYZ"));
// XYDADCEJSYBMDLLTREBEF

writeOutput(nanoId.generate(size=12));
// 2PBPRu7HRoJP

writeOutput(nanoId.generate("ABCDEFGHIJKLMNOPQRSTUVXYZ", 12));
// THTMYMVEGMAV
```

## nanoId.setAlphabet(_alphabet_)

Sets a custom characters for all subsequent ID generations.
```js
nanoId.setAlphabet("ABCDEFGHJKLMNPQSTUVWXYZ");
// no output
```

## nanoId.setSize(_integer_);

Sets custom string length for all subsequent ID generations.
```js
nanoId.setSize(12);
// no output
```

## To Review

Test to determine if using Java native `java.security.SecureRandom` provides any benefit.
