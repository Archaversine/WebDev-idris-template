# Basic Idris WebApp Template

This repository serves as a bare minimum template for creating frontends with Idris

To compile the javascript file, run (with idris2 installed on your system):

```
idris2 --build
```

Then a `basic-web-app.js` file will automatically generated next to the `index.html` file.
You can then open the `index.html` file in a browser of your choosing.

## Code Example

The essentials of the code in `Main.idr`:

```haskell
MyButton : DomElement Void
MyButton = ElementFromID "button"

MyLabel : DomElement Int
MyLabel = ElementFromID "label"

main : IO ()
main = do 
    addEventListener MyButton "click" $ do 
        modifyValue MyLabel (+1)
```