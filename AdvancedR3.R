# Advanced R 1st Edition 
# Ch.10 Functional Programming


# 3가지 공부
# anonymous function 익명 함수
# closure 함수에 의해 작성된 함수
# lists of functions 리스트로 된 함수


# 10.1 Motivation (왜 함수형 프로그래밍 작성이 필요한가)
# 사회과학에서 -99를 결측치로 사용. 아래 데이터.
# -99인 원소를 NA로 바꿔보자.

set.seed(1014)
df <- data.frame(replicate(6, sample(c(1:10, -99), 6, rep = TRUE)))
names(df) <- letters[1:6]
df 


# 비효율적인 코딩
df$a[df$a == -99] <- NA
df$b[df$b == -99] <- NA
df$c[df$c == -98] <- NA # 오타
df$d[df$d == -99] <- NA
df$e[df$e == -99] <- NA
df$f[df$e == -99] <- NA
df

# 근데 만약에 결측치가 단순 -99가 아니라 더 다양한 값으로 표현이 됐다면?
# 혹은 내가 copy & paste 과정에서 오타를 낸다면?



# 효율적인 코딩으로 가보자.
# 함수를 작성하면?
# -98과 같은 오타는 해결 가능함
# 그러나 copy & paste 해야한다는 단점은 여전함.

fix_missing <- function(x) {
    x[x == -99] <- NA
    x
}
df$a <- fix_missing(df$a)
df$b <- fix_missing(df$b)
df$c <- fix_missing(df$c)
df$d <- fix_missing(df$d)
df$e <- fix_missing(df$e)
df$f <- fix_missing(df$e)
df


# 따라서 lapply와 fix_missing()을 연계해서 쓰면?
# 그 전에 함수형이란 무엇인가? 왜 중요한가?
# 함수를 입력값으로 사용하는 함수를 함수형이라고 함.
# 함수형에 사용하는 입력항목 중 dotdotdot(...)의 의미는?


# lapply는 3개의 argument가 있음
# 함수가 적용될 리스트 객체, 적용시킬 function, and dot-dot-dot
# lapply는 list로 결과값을 반환함.


fix_missing <- function(x) {
    x[x == -99] <- NA
    x
}

# lapply의 결과값은 list로 나오고,
# 데이터프레임은 list에 기반한 자료구조.
# []로 subsetting을 하면 자료형이 유지되므로
# df[] <- lapply(...) 로 해보자


# lapply는 R로 작성해보면,
out <- vector("list", length(x))
for (i in seq_along(x)) {
    out[[i]] <- f(x[[i]], ...)
} # 이런 느낌이다.


df[] <- lapply(df, fix_missing) 
df


# 이런 함수형을 사용하면 생기는 장점은,
# code가 compact 해지고, 수정 또한 간편하며, 실수 또한 적다.


df[1:5] <- lapply(df[1:5], fix_missing) # 이런 식으로 특정 컬럼만도 적용 가능




# 만약 결측값을 나타내는 값으로 한 개 이상의 값이 사용됐다면?
# 비효율적인 코딩

fix_missing_99 <- function(x) {
    x[x == -99] <- NA
    x
}
fix_missing_999 <- function(x) {
    x[x == -999] <- NA
    x
}
fix_missing_9999 <- function(x) {
    x[x == -9999] <- NA
    x
}


# 클로저를 만들어 문제를 간단하게 해결해보자.
# 여기서 클로저란, 함수를 반환하는 함수를 사용해서 만든 함수를 의미.

missing_fixer <- function(na_value) {
    function(x) {
        x[x == na_value] <- NA
        x
    }
}
fix_missing_99 <- missing_fixer(-99)
fix_missing_999 <- missing_fixer(-999)
fix_missing_99(c(-99, -999))



# Extra argument
# 그 외의 좋은 적용사항
fix_missing <- function(x, na.value) {
    x[x == na.value] <- NA
    x
}

summary <- function(x) {
    funs <- c(mean, median, sd, mad, IQR)
    lapply(funs, function(f) f(x, na.rm = TRUE))
}



# 10.2 Anonymous functions
# R에서 모든 것은 객체이며, 함수와 심볼 역시 객체이다. 함수 객체를 반드시 심볼 할당을 해서 사용해야 할 필요는 없다.

# 함수 이름을 사용할 필요가 없거나,
# 클로저를 생성할 경우(함수 내의 함수를 반환하는) Anonymous function을 사용하면 된다.

data("mtcars")
lapply(mtcars, function(x) length(unique(x)))

# 무명함수도 함수이다. 따라서 무명함수를 구성하는
# 세가지 부분은 동일하다

formals(function(x=4) g(x) + h(x))
body(function(x=4) g(x) + h(x))
environment(function(x = 4) g(x) + h(x))


# 무명함수를 사용(call)할 때 주의해야 하는 부분?
function(x) 3() # x에 뭘 넣든 3을 반환하는 함수, 마지막에 ()는 문법오류
(function(x) 3)() # function(x) 3, 정상적으로 작성된 것.괄호로 함수를 감싸준 후, ()로 출력. 맞는 문법


(function(x) x + 3)(10) # 무명함수를 콜할땐 이런식으로.

# 굳이 심볼에 할당하면,
f <- function(x) x + 3
f(10)




# 10.3 Closures
# 함수 안에 환경정보가 포함되기 때문에, closure라고 부름.
# lexical scoping에 사용.
# closure를 만든다고 할 때 closure란 무엇인가?
# 부모 함수의 환경을 감싸 그 모든 변수에 접근할 수 있기 때문.
# 연산을 제어하는 부모 수준과 자식 수준의 2단계 파라미터를 가지기 때문에 유용하다.


# function factory
# 내부의 함수를 보통 closure라고 함.
power <- function(exponent) {
      print(environment())
        function(x) {
      x ^ exponent
    }
}
square <- power(2)
square(2)
square(4)

cube <- power(3)
cube(2)

# square라는 함수는 2^exponent인 함수지만
# 출력해보면 x^expnenet로 나옴.
# 왜냐면 함수 자체는 바뀌지 않기 때문이다.
# enclosing 환경만 바뀔 뿐임.
square
cube

# 제대로 보고싶으면
as.list(environment(square)) # 자식 함수에, 부모환경 내의 값이 들어가 있음.


# 중요!
# 클로져의 부모환경은 클로져를 생성한 함수의 실행환경이다.

power <- function(exponent) {
    print(environment())
    function(x) x ^ exponent
}

zero <- power(0) # 부모함수의 실행환경 print로 출력
zero
as.list(environment(zero))
formals(zero)
environment(zero) # 둘이 같다
body(zero)
cube <- power(3)
environment(cube)

# exe env는 원래 사라지지만, 함수공장에서 만들어진 클로저는
# 부모환경에 대한 정보(그 안의 심볼이나 객체 등)를 캡쳐하기 때문에, 가지고 있게 된다.
# 즉 클로져는 부모환경을 캡쳐하기 때문에, 부모환경에서의 선언된 객체에 접근할 수 있다.


# 예외. primitive function 들은 C코드로 짜여져있고, 클로저가 아님.


# 10.3.1 Function factories
# 함수 공장은 새로운 함수를 생성하는 데 사용하는 함수를 의미함,
# 함수를 사용했을 때 결과로 반환되는 객체가 다시 새로운 함수가 됨.



col.fun <- colorRampPalette((c("blue","red")))


typeof(col.fun) # closure 이므로 반환 객체가 함수일 것이다.
class(col.fun)

col.fun(30) # 블루에서 레드로 끝나는 중간 스펙트럼 색을 알아서 10개 출력

par( mar = rep(0,4))
plot( rep(1,100000), col = col.fun( 100000 ), 
      pch = 16, cex = 4,
      xlab = "", ylab = "", axes = FALSE )


# 10이 아니라 20을 넣어보자
col.fun(20)
par( mar = rep(0,4))
plot( rep(1,20), col = col.fun( 20 ), 
      pch = 16, cex = 4,
      xlab = "", ylab = "", axes = FALSE )


# 어떻게 col.fun() closure는 어떻게 연속색상을 만들어낼까?
# colorRampPalette의 실행환경에 대한 정보를, 팔레트 자식함수인
# col.fun()이 갖고 있을 것.








# 함수 공장에 대해 쉽게 이해해보기 위한 예제
# function factory를 하나 만들어보자.
draw <- function( x )
{
    function(FUN, ... ) FUN( x, ... )
}

draw.FUN <- draw( x = rnorm(1000) ) # 자식함수 생성.
draw.FUN

# draw가 실행될 떄의 실행환경 정보를 가지고 있음.
# draw.fun 함수는 x라는 입력값을 기억하고 있다.


par( mfrow = c(2,2), mar = rep(0,4) )
draw.FUN( FUN = hist, col = topo.colors(4)[2], 
          main = "", xlab = "", ylab = "", axes = F )
draw.FUN( FUN = hist, col = topo.colors(4)[4], 
          main = "", xlab = "", ylab = "", axes = F )
draw.FUN( FUN = boxplot, col = topo.colors(4)[2], 
          pars = list(boxwex = 0.3),
          xlab = "", ylab = "", axes = F )
draw.FUN( FUN = boxplot, col = topo.colors(4)[4],
          pars = list(boxwex = 0.3),
          xlab = "", ylab = "", axes = F )
# 좌우의 그래프가 같다!
# 이 말은 draw.Fun() 함수가 사용될 때 draw() 함수에서 입력값으로 지정한 
# rnorm(1000)이 재추출되지 않고 다시 사용되고 있다.
# 즉 draw.fun 이라는 자식함수가, 부모환경이 되는 draw의 실행환경에서의 x 정보를 기억하고 있다는 뜻이다.

# 즉 함수공장이 실행될 때 생겨난 실행환경에 그 비밀이 있음.
# draw 함수는 무명함수를 사용하고 있다.



# 10.4 Lists of functions
# R 객체 중 가장 유연한 구조를 갖고 있는 객체가 리스트. 어던 유형이든 원소로 표현할 수 있음.
# 함수도 객체이므로 리스트에 원소 포함 가능.
# 함수 리스트를 만들면 좋은 이유? 이점은?


# 같은 함수 여러모양으로 작성해보기
compute_mean <- list( 
    
    base = function(x) mean(x),
    
    sum = function(x) sum(x) / length(x),
    
    manual = function(x) {
        total <- 0
        n <- length(x)
        for (i in seq_along(x)) {
            total <- total + x[i] / n
        }
        total
    }
    
)

x <- runif(1e5)

system.time(compute_mean$base(x))
system.time(compute_mean[[2]](x))
system.time(compute_mean[["manual"]](x))
lapply(compute_mean, function(f) system.time(f(x))) # 이렇게 한번에 측정할 수도 있음. 

# 각 리스트를 인덱스로 불러서 직접 각각 계산하지 말고, lapply로 줄일 수 있음
lapply(compute_mean, function(f) f(x))

# 각 다른 함수도 리스트에 넣으면 편리함.
x <- 1:10

funs <- list(
    sum = sum,
    mean = mean,
    median = median
)

lapply(funs, function(f) f(x))

# 만약 결측치가 있다면?
funs2 <- list(
    sum = function(x, ...) sum(x, ..., na.rm = TRUE),
    mean = function(x, ...) mean(x, ..., na.rm = TRUE),
    median = function(x, ...) median(x, ..., na.rm = TRUE)
)
lapply(funs2, function(f) f(x))



# 이렇게 작성 하는 것 보다는 funs 함수로 작성한 후, lapply안에서 na.rm을 추가가 좋음
lapply(funs, function(f) f(x, na.rm = TRUE))


# 10.4.1 Moving lists of functions to the global environment
# 함수 리스트는 떄때로 특정 문법을 대체하여 사용하는데 활용할 수 있다.


simple_tag <- function(tag) {
    force(tag)
    function(...) {
        paste0("<", tag, ">", paste0(...), "</", tag, ">")
    }
}
tags <- c("p", "b", "i")
html <- lapply(setNames(tags, tags), simple_tag)
html$p("This is ", html$b("bold"), " text.")

# 단점은 달러싸인을 자주 써야한다는 것.
# 어떻게 해결할까?
#1
with(html, p("This is ", b("bold"), " text."))


#2
attach(html)
p("This is ", b("bold"), " text.")
detach(html)


#3
list2env(html, environment())
p("This is ", b("bold"), " text.")
rm(list = names(html), envir = environment()) 


# force는 왜 쓰는가
# lazy evaluation이 아니라, 강제로 loop안의 i를 각각 평가시켜놓기 위해

f <- function(y) function() y
lf <- vector("list", 5)
for (i in seq_along(lf)) lf[[i]] <- f(i)
lf[[1]]() # returns 5

 
g <- function(y) { force(y); function() y }
lg <- vector("list", 5)
for (i in seq_along(lg)) lg[[i]] <- g(i)
lg[[1]]()  # returns 1




# Case Study : numerical integration
# 각각 높이를 재는 방식이 다름.
# 사각형 한개로 재는 법
# 오차가 큼

midpoint <- function(f, a, b) {
    (b - a) * f((a + b) / 2)
}

trapezoid <- function(f, a, b) {
    (b - a) / 2 * (f(a) + f(b))
}

midpoint(sin, 0, pi)
trapezoid(sin,0,pi)


# 구간을 10둥분해서 구하기
# 정확성이 올라감.
# 그러나 코드가 반복되는 부분이 많음.

midpoint_composite <- function(f, a, b, n = 10) {
    points <- seq(a, b, length = n + 1)
    h <- (b - a) / n
    
    area <- 0
    for (i in seq_len(n)) {
        area <- area + h * f((points[i] + points[i + 1]) / 2)
    }
    area
}

trapezoid_composite <- function(f, a, b, n = 10) {
    points <- seq(a, b, length = n + 1)
    h <- (b - a) / n
    
    area <- 0
    for (i in seq_len(n)) {
        area <- area + h / 2 * (f(points[i]) + f(points[i + 1]))
    }
    area
}


# 그러면 이렇게 줄일 수 있음.
composite <- function(f, a, b, n = 10, rule) {
    points <- seq(a, b, length = n + 1)
    
    area <- 0
    for (i in seq_len(n)) {
        area <- area + rule(f, points[i], points[i + 1])
    }
    
    area
}

composite(sin, 0, pi, n = 10, rule = trapezoid)

midpoint_composite(sin, 0, pi, n = 10)






#### AdvR Ch 11

# 11 Functionals, 함수형
# 함수를 입력항목으로 이용하는 함수를 의미함.
# 클로져란 함수에 의해 반환된 함수를 의미한다.

# arguments f는 함수역할을 함.
# 유니폼에서 1000개를 랜덤 생성한 후, 받은 함수 f에 입력값으로 넣음.
randomise <- function(f) f(runif(1e3))   
randomise(mean)
randomise(mean) # 출력값이 항상 같지 않음.
randomise(sum)
?lapply

# 함수형은 함수를 입력항목으로 사용하는함수를 의미함. 
# R에서 대표적인 함수형은 lapply, apply, tapply 등.
# 반복문보다 명확성이 좋고, 일반적으로 연산속도도 나으나 항상 그런것은 아님.

# lapply()
# lapply는 입력으로 받은 리스트의 원소 각각을 정의한 함수에 입력해서 다시 리스트의 원소로 넣어줌
# lapply함수형의 입력항목은 atomic vector or list
# 반환도는 객체의 유형은 list
# C언어로 작성됐으나, R로 표현하면 다음과 같다.
# lapply의 순서는
# 결과를 저장할 리스트 객체를 생성, 리스트의 각 원소를 함수 f를 적용, 결과값을 리스트에 채움.

lapply2 <- function(x, f, ...) {
    out <- vector("list", length(x))
    for (i in seq_along(x)) {
        out[[i]] <- f(x[[i]], ...)
    }
    out
}


# 랜덤 데이터를 만들어보자
l <- replicate(20, runif(sample(1:10, 1)), simplify = FALSE) # simplify=FALSE는 리스트로 반환해주기 위함.

# 반복연산자로 빈 리스트를 만든 후, l의 각각의 길이를 넣어보자
out <- vector("list", length(l))
for (i in seq_along(l)) {
    out[[i]] <- length(l[[i]])
}
unlist(out)

# lapply를 사용하면 이렇게 간단하다
unlist(lapply(l, length))


# lapply는 데이터프레임 객체에도 사용할 수 있다. 데이터프레임은 리스트에 별도의 클래스를 부여한 리스트의 한 종류이므로.
# 데이터프레임은 각 컬럼들이 리스트 원소로 들어가있으므로 lapply시 컬럼마다 적용이 된다.
unlist(lapply(mtcars, class))
unlist(lapply(mtcars, mean))

# 데이터프레임 형식을 유지하고 싶으면 [] 추출 연산자를 사용하면 된다
mtcars[] <- lapply(mtcars, function(x) x/mean(x))
class(mtcars); head(mtcars)

# lapply 함수의 argument들을 봐보자
args(lapply)

# 만약 x의 각 원소를 fun 함수의 첫번째가 아닌 항목에 적용하고 싶으면 간단한 무명함수를 사용하면 된다,
trims <- c(0, 0.1, 0.2, 0.5)
dat <- rcauchy(1000)


# trims 객체를 mean함수의 trim 인자에 넣어줌. mean 함수의 첫번째 인자가 아닌 뒤 인자에 넣은것,
unlist( lapply(trims, function(trim) mean(dat, trim = trim)) )

# dot dot dot 입력항목을 사용하여 아래와 같이 함수를 사용할 수도 있음.
unlist(lapply(trims,mean,x=dat))
args(mean) # mean이 계산될 데이터는 x로 지정하게 되어 있음. 이 x를 dat으로 지정시키면 trims객체는 x가 아닌 그 뒤의 dotdotdot으로 들어가서 trim인자로 들어간것.


# 11.2.1 Looping patterns
# R에서 일반적으로 사용 가능한 세 가지 반복문의 패턴
# 1. for (x in xs)
# 2. for (i in seq_along(xs))
# 3. for (nm in names(xs))

# 첫번째 형태는 추천하지 않음. 그 이유는?

xs <- runif(1e3)
res <- c()
for (x in xs) {
    # This is slow!
    res <- c(res, sqrt(x))
}

# 계속 기존 원소들을 카피해야하므로 느림.

# 그래서 두번째 형식의 반복문을 추천
# seq_along은 1:length(xs)와 같음.
# index를 이용해서 loop
res <- numeric(length(xs))

for (i in seq_along(xs)) {
    res[i] <- sqrt(xs[i])
}


# lapply로 위의 세 반복문 형태를 대체할 수 있음

lapply(xs, function(x) {})
lapply(seq_along(xs), function(i) {})
lapply(name(xs), function(nm) {})
# 상황에 맞게 선택해서 쓰기.

# 11.2 lapply() 의 친구들
# lapply, sapply, vapply(), Map(), mapply()

# atomic vector로 반환해주는 apply계열 함수 sapply, vapply
# R을 에디터 창에서 대화형으로 사용할 때는 sapply가 좋고, 함수 안에서 사용할 때는 vapply가 좋다.
# 왜냐면 vapply는 오류를 출력해주므로
# 대화형 모드에서 sapply를 사용하면 이런 에러를 발견할 수 있으나 함수 내에서 사용되면 에러를 발견하기 힘듦.

lapply(mtcars, is.numeric)
sapply(mtcars, is.numeric)
vapply(mtcars, is.numeric, logical(1)) # 각각의 반환되는 값들을 보니, 하나의 값들만을 반환하고, 그 형태가 bool이므로, 반환되는 객체의 유형을 logical(1)로 지정.

sapply(list(), is.numeric)
vapply(list("a"), is.numeric, character(1)) # is.numeric은 bool형이므로 logical로 들어가야 하니 오류사인을 보여줌.


# 데이터 프레임 객체의 각 열에 포함된 클래스 정보를 추출할 때 발생할 수 있는 문제점
df <- data.frame(x = 1:10, y= letters[1:10])
sapply(df, class)
vapply(df, class, character(1))


df2 <- data.frame(x = 1:10, y= Sys.time() + 1:10)



sapply(df2,class) 
vapply(df2, class, character(1)) # y의 클래스는 두개이므로 오류가 뜸.

# sapply는 lapply를 기본으로 작성된 함수로, 마지막 단계에서 리스트를 벡터로 전환함.
# vapply는 리스트가 미리 지정된 유형의 벡터에 결과값을 채움. 교재 그림 참고.


# lapply에서 마지막에 아토믹벡터로 변환해주는게 sapply, 단순 lapply의 wrapper이며 마지막에
# simpify2array만 추가된것

# vapply는 리스트가 미리 지정된 유형의 벡터에 결과값을 채우는 것이다.


# multiple inputs
# Mad and mapply
# 여러개의 입력값을 넣는 mapply
# lapply는 한개의 입력항목만 지정할 수 잇다. 만약 여러 입력항목들을 지정해야 할 경우 lapply는 부적절

# 가중평균의 예
args(replicate)

xs <- replicate(5, runif(10), simplify = FALSE)
ws <- replicate(5, rpois(10, 5) + 1, simplify = FALSE)

# xs 각 열의 산술평균을 계산하려면
unlist(lapply(xs,mean))

# 가중치 ws를 사용해서 xs의 가중평균읠 계산해보면
# 무명함수를 이용하면

unlist(lapply(seq_along(xs), function (i) {
    weighted.mean(xs[[i]], ws[[i]])
})) # 코드 명확성 떨어짐


# Map 이용하면 이렇게 간단함.
unlist(Map(weighted.mean,xs,ws)) 
# 주의할 점은 Map() 함수형의 첫번째 입력항목은 함수라는 것, lapply는 두번째 입력항목이 함수였음.


# 일반적으로 Map 함수형을 사용하는 것이 lapply를 사용하는 것보다 코딩이 더 간단하고 명확함.
# 어떤 경우는 Map으로 다단꼐로 계산하는 것이 명확함
# 아래 lapply 사용 예시를 Map 다단계로 나눠보자

# 이걸
data('mtcars')
mtcars[] <- lapply(mtcars, function(x) x / mean(x))


# 이렇게
mtmeans <- lapply(mtcars, mean)
mtmeans[] <- Map(`/`, mtcars, mtmeans)


# 만약 가중평균의(weighted.mean())의 다른 입력항목(na.rm같은)의 값을 지정해야 할 때는 아래와 같이 무명함수를 사용할 수 있음.
Map(function(x, w) weighted.mean(x, w, na.rm = TRUE), xs, ws)




# Rolling computatins
# 만약 필요로하는 반복문을 대체할 함수형이 기본 R패키지에 존재하지 않는다면 직접 작성을 해야한다.
# 반복되는 패턴을 파악해서 자신만의 함수형을 구현해보자.
# 예시로 자료를 와난하게 변하게 만들어주는 평활함수를 만드는 데 관심ㅇㅣ있다고 해보자.
rollmean <- function(x, n) {
    out <- rep(NA, length(x))
    
    offset <- trunc(n / 2)
    for (i in (offset + 1):(length(x) - n + offset + 1)) {
        out[i] <- mean(x[(i - offset):(i + offset - 1)])
    }
    out
}
x <- seq(1, 3, length = 1e2) + runif(1e2)
plot(x)
lines(rollmean(x, 5), col = "blue", lwd = 2)
lines(rollmean(x, 10), col = "red", lwd = 2)



# 만약 꼬리가 두터운거로부터 나왔다면

x <- seq(1, 3, length = 1e2) + rt(1e2, df = 2) / 3
x
plot(x)
lines(rollmean(x, 5), col = "red", lwd = 2)
lines(rollmean(x, 30), col = "red", lwd = 2)




rollapply <- function(x, n, f, ...) {
  offset <- trunc(n / 2)
  locs <- (offset + 1):(length(x) - n + offset + 1)
  num <- vapply(
    locs, 
    function(i) f(x[(i - offset):(i + offset)], ...),
    numeric(1)
  )
  num 
}
plot(x)
lines(rollapply(x, 10, median), col = "blue", lwd = 2)
lines(rollapply(x, 5, mean), col = "red", lwd = 2)




# 11.3
# 고차원 데이터구조에 적용할 수 있는 방법
# apply, sweep, outer는 매트릭스와 동작
# tapply는 다른 벡터로 정의된 그룹으로 벡터를 요약


# apply는 sapply의 변형으로 매트릭스와 어레이에 적용됨
# apply는 각 행과 열을 하나의 숫자로 축소하여 매트릭스나 어레이를 요약하는 연산

# apply는 네가지 인자를 가짐
# X, 요약할 매트릭스나 어레이
# MARGIN, 요약할 차원을 제공하는 정수형 벡터, 1=행, 2=열, 기타
# FUN, 요약 함수
# ..., FUN에 전달될 다른 인자

a <- matrix(1:20, nrow=5)
apply(a,2,mean)
apply(a,1,mean)


# apply는 반환되는 객체의 dimension을 확인하기 힘드므로 주의.
apply(a,1,identity) # 하면 차원이 바뀜

# sweep
# 요약 통계량 값들을 한꺼번에 처리(sweep) 가능.

x <- matrix(rnorm(20, 0, 10), nrow = 4)
x1 <- sweep(x, 1, apply(x, 1, min), `-`)
x2 <- sweep(x1, 1, apply(x1, 1, max), `/`)


# outer
outer(1:3, 1:10, `+`)


# 그룹화된 apply => tapply
# tapply는 각 행이 다른 수의 열을 가진 어레이를 허용하는 apply를 일반화한 것
# 요약에서 자주 사용
pulse <- round(rnorm(22, 70, 10 / 3)) + rep(c(0, 5), c(10, 12))
group <- rep(c("A", "B"), c(10, 12))

tapply(pulse, group, length)
tapply(pulse, group, mean)
sapply(split(pulse,group),mean)


# 이렇게 생각하면 tapply는 split과 sapply를 결합한 것

tapply2 <- function(x, group, f, ..., simplify = TRUE) {
  pieces <- split(x, group)
  sapply(pieces, f, simplify = simplify)
}

tapply2(pulse, group, length)


# 11.4 리스트 조작
# Map, reduce, filter

# Reduce()
# 동시에 두 개의 인자로 재귀적으로 함수를 호출하여 벡터x를 하나의 값으로 축소한다. 
# Reduce(f, 1:3)은 f(f(1,2),3)과 동일.

Reduce(`+`, 1:3) # -> ((1 + 2) + 3)
Reduce(sum, 1:3) # -> sum(sum(1, 2), 3)

# 이럴 떄 유용하다.
# 각 리스트 별 속한 원소의 종류가 궁금하다고 하자

l <- replicate(5, sample(1:10, 15, replace = T), simplify = FALSE)
str(l)


intersect(intersect(intersect(intersect(l[[1]], l[[2]]),l[[3]]), l[[4]]), l[[5]])

# 이걸 리듀스로 하면
Reduce(intersect,l)


# 11.4.2 predicate
# bool 값을 반환하는 함수
# Filter, Find, Postition

# Filter는 매칭되는 요소만을 선택
# Find는 일치하는 첫번째 요소 반환
# position은 일치하는 첫번쨰 요소의 인덱스 반환

where <- function(f, x) {
  vapply(x, f, logical(1))
}

df <- data.frame(x = 1:3, y = c("a", "b", "c"), z=4:6);df
where(is.numeric, df)
str(df)

str(Filter(is.numeric,df))

str(Find(is.numeric,df))

Position(is.numeric,df)


mode(df)
mode(Filter(is.numeric,df))
# 11.5 Mathmatical functionals 
# 함수를 입력항목으로 삼으므로 얘네도 다 functionls

integrate(sin, 0, pi)  # 적분
uniroot(sin, pi * c(1 / 2, 3 / 2)) %>% str() # 근
str(optimise(sin, c(0, 2 * pi))) # 극값
str(optimise(sin, c(0, pi), maximum = TRUE))

# lapply, sapply, vapply, apply, tapply, Map, Reduce, Filter, FInd, Position
