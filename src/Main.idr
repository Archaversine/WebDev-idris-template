module Main

data DomElement : Type -> Type where 
    ElementFromID : (name : String) -> DomElement a

interface JsValue a where 
    toJsValue   : a -> String
    fromJsValue : String -> a

JsValue Int where 
    toJsValue   = show
    fromJsValue = cast

%foreign "javascript:lambda:(name, etype, f)=>document.getElementById(name).addEventListener(etype, f)"
prim__addEventListener : String -> String -> IO () -> PrimIO ()

addEventListener : HasIO io => DomElement a -> String -> IO () -> io ()
addEventListener (ElementFromID name) etype f = primIO (prim__addEventListener name etype (liftIO f))

%foreign "javascript:lambda:name=>document.getElementById(name).innerHTML"
prim__getInnerHTML : String -> PrimIO String

getInnerHTML : (HasIO io, JsValue a) => DomElement a -> io a
getInnerHTML (ElementFromID name) = fromJsValue <$> primIO (prim__getInnerHTML name)

%foreign "javascript:lambda:(name, newValue)=>document.getElementById(name).innerHTML = newValue"
prim__setInnerHTML : String -> String -> PrimIO ()

setInnerHTML : (HasIO io, JsValue a) => DomElement a -> a -> io () 
setInnerHTML (ElementFromID name) value = primIO (prim__setInnerHTML name (toJsValue value))

modifyValue : (HasIO io, JsValue a) => DomElement a -> (a -> a) -> io () 
modifyValue elem f = do 
    value <- getInnerHTML elem
    setInnerHTML elem (f value) 

MyButton : DomElement Void
MyButton = ElementFromID "button"

MyLabel : DomElement Int
MyLabel = ElementFromID "label"

main : IO ()
main = do 
    addEventListener MyButton "click" $ do 
        modifyValue MyLabel (+1)