## Parts list generator thing

Takes a list like

```
<farnell> [mouser] <qty> [arbitrary notes]
<farnell> [mouser] <qty> [arbitrary notes]
```

and outputs useful markdown / csv lists and things

Is ruby because [nokogiri](http://www.nokogiri.org/) and [parallel](https://github.com/grosser/parallel)

### Prerequisites?

```
gem install nokogiri parallel
```

or something. sorry

### Which files??

`parts` --> `Parts.md` in the directory ruby is run from.

### What exactly does it output??

Lines that meet the above specification will be replaced by lines from
a markdown table. Other lines get preserved

```
| Part | Description | Farnell # | Quantity Required | Notes
| ---  | ---         | ---       | ---               | ---
```

If you put this table header first you'll get a nice table that
renders on github etc. Yay!

### How do I use it??

git submodules seem like a good idea here
