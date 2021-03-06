<!--
# Type anonymity
-->
# クロージャを受け取る関数

<!--
Closures succinctly capture variables from enclosing scopes. Does this have
any consequences? It surely does. Observe how using a closure as a function
parameter requires [generics], which is necessary because of how they are
defined:
-->
クロージャが周辺の環境から変数を取得するやり方は非常に明瞭です。何か注意すべき点はあるのでしょうか？
もちろんです。関数内でクロージャを使う場合、[ジェネリック]型を使用する必要があります。詳しく見ていきましょう。

```rust
// `F` must be generic.
// `F` はジェネリック型でなくてはならない
fn apply<F>(f: F) where
    F: FnOnce() {
    f();
}
```

<!--
When a closure is defined, the compiler implicitly creates a new
anonymous structure to store the captured variables inside, meanwhile
implementing the functionality via one of the `traits`: `Fn`, `FnMut`, or
`FnOnce` for this unknown type. This type is assigned to the variable which
is stored until calling.
-->
クロージャが定義されると、コンパイラは裏側で、無名の構造体を作り、そこにクロージャによって使用される外側の変数を入れます。同時に`Fn`、`FnMut`、`FnOnce`という名のトレイトのいずれか一つを介してこの構造体に関数としての機能を実装し、実際に呼び出されるまで待ちます。

<!--
Since this new type is of unknown type, any usage in a function will require
generics. However, an unbounded type parameter `<T>` would still be ambiguous
and not be allowed. Thus, bounding by one of the `traits`: `Fn`, `FnMut`, or
`FnOnce` (which it implements) is sufficient to specify its type.
-->
この無名構造体は型が未指定(`unknown`)なため、関数を実行する際にはジェネリクスが必要とされます。とはいえ、`<T>`で指定するだけでは、まだ曖昧です。（訳注: `&self`、`&mut self`、`self`のいずれをとるのかがわからないため）そのため、`Fn`、`FnMut`、`FnOnce`のいずれか一つを実装することで対応しています。

```rust,editable
// `F` must implement `Fn` for a closure which takes no
// inputs and returns nothing - exactly what is required
// for `print`.
// `F`は`Fn`を実装していなくてはならず、`Fn`は引数と返り値を持たない。
// `print`は文字をプリントするだけのクロージャなので、これが正しい。
fn apply<F>(f: F) where
    F: Fn() {
    f();
}

fn main() {
    let x = 7;

    // Capture `x` into an anonymous type and implement
    // `Fn` for it. Store it in `print`.
    // `x`を無名の構造体に入れ、それに対し`Fn`を実装する。
    // （訳注: ここでは`Fn`は`fn Fn(&self) -> {println!("{}", &self)}`）
    // その構造体を`print`にアサインする。
    let print = || println!("{}", x);

    apply(print);
}
```

### See also:

[A thorough analysis][thorough_analysis], [`Fn`][fn], [`FnMut`][fn_mut],
and [`FnOnce`][fn_once]

[generics]: ../../generics.md
[fn]: https://doc.rust-lang.org/std/ops/trait.Fn.html
[fn_mut]: https://doc.rust-lang.org/std/ops/trait.FnMut.html
[fn_once]: https://doc.rust-lang.org/std/ops/trait.FnOnce.html
[thorough_analysis]: https://huonw.github.io/blog/2015/05/finding-closure-in-rust/
