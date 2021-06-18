# 6. Function
# 함수를 구성하고 있는 세 가지 핵심요소는 무엇인가?
# arguments, body and environment
# 함수 또한 객체이다.
# 이 중 environment는 무엇인가?


# formals() 함수
# arguments의 항목들을 보여줌

# body() 함수
# 함수 내의 body code


# environment()
# 자료구조, 그 함수가 객체들을 어떻게 찾아들어가는가.
# 심볼(names)를 사용해서 값을 찾아 들어감.
# 어떻게 찾아들어가는지 정의하는 자료구조.
# 환경은 이름-값 리스트로 이루어진 프레임과 상위환경을 가리키는 포인터로 이루어져 있다.

# environment란 함수가 심볼에 부여된 객체를 찾는 방법을
# 결정하는 자료구조를 말한다.
# 일반적으로 환경은 이름-값 리스트로 이루어진
# 프레임과 상위 환경을 가리키는 포인터로 구성된다.
# 함수가 생설될 때의 환경인 울타리 환경(enclosing environment)에 대한 정보를 포함

# 함수 객체가 할당된 심볼을 사용해서 출력하면
# 함수의 세가지 구성 요소 중 arguments와 body를 확인 가능

# 함수 객체에 환경은 항상 포함되어 있지만
# 전역환경(global env)에 등록되지 않은 함수의 경우에만
# 환경에 관련한 정보를 출력하여 보여줌.


f02 <- function(x,y) {
    # A comment
    x+y
}
f02 # global env에 등록되어 있기 때문에 환경이 출력되지 않음.


mean # base, namespace에 등록되어 있기 때문에 환경이 출력됨.


formals(f02) # arguments 출력
body(f02) # 주석은 출력되지 않음.
environment(f02) # 환경 출력
environment(mean)

# 함수도 객체기에 attributes를 부여, 확인할 수 있음.

attributes(f02)
# srcref 속성은 printing을 하는데 사용함
# body() 와의 차이가 있음.

attr(f02, "srcref") # 주석이 포함돼서 나옴.
body(f02) # 주석은 안나옴
body(mean)

# 6.2.2 Primitive functions
# base 패케지에 포함된 함수들.
# R로 컴파일된 C코드

sum
`[`


# C코드로 전달하기 전에 입력항목을 어떻게 처리하는 지에 따라 privitive 함수를
# 두가지 유형으로 나눔
# 안중요

# primitive 함수는 formals, body, environment를 NULL로 반환
formals(sum)
body(sum)
environment(sum)


# 6.2.3 First-class functions
# 심볼에 함수를 할당할 수 있고,
# 함수를 arguments으로 전달할 수 있고,
# 함수를 반환값으로 하는 함수를 작성할 수 있음.
# 이 세가지 조건을 만족해야 first class function임.
# R 함수는 first class function이다.
 


# 어떤 경우에는 심볼이 없는 함수를 사용함
# anonymous function
# 심볼을 짓는 것이 번거로울 때 사용.
# 별도의 심볼 객체를 생성해서 바인딩 시키기 귀찮을때.

lapply(mtcars, function(x) length(unique(x)))


# 함수들로 이루어진 리스트인 함수 리스트.
# 반복되는 코드를 효율적으로 줄일 수 있어서.
funs <- list(
    half = function(x) x/2,
    double = function(x) x*2
)
funs$double(10)


lapply(funs, function(f)f(x=10))
# funs 함수의 리스트의 각각의 함수를 사용해서 arguments를 10을넣어라

typeof(f02)
# R에서는 functions = closures 를 의미함.




# 6.2.4 invoking a function
# 함수 호출
# 함수에 넣고싶은 arguments가 데이터프레임이면?
# do.call
mean(1:10, na.rm=T)
args <- list(1:10, na.rm=T)

# do.call(함수, 인자)
do.call(mean, args) # = mean(1:10, na.rm=T)

# 6.3 생략

# 6.4 Lexical scoping 
# 중요!
# 심볼에 바인딩된 객체를 찾는 행위를 scoping이라고 함.

x <- 10
g01 <- function() {
    x <- 20
    x
}
g01()
x

# 함수 실행 시 새로운 환경이 생성됨.
# 각각의 x들은 서로 다른 환경 내에 있음.
# 따라서 global env. 안의 x는 바뀌지 않음.
# 함수가 정의될때 environment를 가지고 있으므로
# 거기서 먼저 찾아서 출력해줌.


g02 <- function() {
    y<-20
    x
}
g02()


# 이 함수에서 lexicla scoping이 일어나게 되면
# x는 함수의 환경에 등록되어 있지 않으므로
# 그 상위의 환경인 global env에서 찾아서
# x는 10 값을 출력해줌,



# 그렇다면 심볼에 해당하는 객체를 찾아가는 방법은 무엇인가?
# 함수가 어떻게 호출되었는지가 아닌, 어떻게 정의되었는지에 따라 심볼의 값 참조
# Lexical scoping에는 4가지 규칙이 있음.

# Name masking
# Functions versus variables
# A fresh start
# Dynamic lookup


# 6.4.1 Name masking
# Lexical scoping의 기본 규칙 중 1.
# 함수 안에서 사용된 심볼들은 함수 밖에서 선언된 심볼과 구별된다.

x <- 10
y <- 20
g02 <- function() {
    x <- 1
    y <- 2
    c(x,y)
}
g02() # 함수 내에서 선언된 x,y 출력


x <- 2
g03 <- function() {
    y <- 1
    c(x,y)
}
g03() # globla env.에서 등록된 x와 함수 내의 환경에서 선언된 y가 출력
y # global env. 에 등록되어 있던 20에는 영향을 주지 못함. 20으로 출력


# 함수 안에 함수가 등록되어 있을 때, R은 현재 함수 내에서 심볼을 찾게되고,
# 함수가 정의되어있는 환경으로 찾아올라가서 global env. -> loaded package -> empty env 까지 찾게된다.


# 중요!
x <- 1
g04 <- function() {
    y <- 2
    i <- function() {
        z <- 3
        c(x, y, z)
    }
    i()
}
g04()

# i의 env에 서 먼저 z 3을 찾고, 그 상위은 g04의 env에서 y 2를 찾고
# 그 상위인 global env. 에서 x 1을 찾는다.



# 6.4.2 Functions versus variables

g07 <- function(x) x + 1
g08 <- function() {
    g07 <- function(x) x + 100
    g07(10)
}
g08()

# global env에는 g07와 g08에 등록됨.
# g07은 g08 환경 내에도 등록돼있음.
# 따라서 g08 실행 시 110이 출력됨.


g09 <- function(x) x + 100
g10 <- function() {
    g09 <- 10
    g09(g09)
}
g10()

# g10내의 환경 안에 g09 변수는 있으나,
# g09 함수는 없으므로, global env안에 있는 g09함수에
# arguments는 g10 환경 내에 있는 10을 넣게 됨.
# 즉 R에서는 함수형태로, 즉 괄호를 넣게 되면 함수로 인식해서
# 변수와 함수를 구별하게 됨.


# 6.4.3 A fresh start
g11 <- function() {
    if (!exists("a")) {
        a <- 1
    } else {
        a <- a + 1
    }
    a
}
sapply(1:3, function(x) g11())
g11()
g11() # 계속 1로 출력

# 함수가 실행되고 나면 함수의 환경은 사라진다.
# 따라서 항상 !exists("a")는 참이 됨.


a <- 10
g11()
# 만약 global env에 a 값이 있다면
# a+1이 출력될것. g11 env에서는 못찾고, global env를 찾은 것.



# 6.4.4 Dynamic lookup
# Lexical scoping은 언제가 아닌 어디에서 값을 찾아야하는지 결정.
# 즉 함수가 생성되었을 때 함수가 바인딩 되는 환경에서 값을 찾게 된다는 것
# 반면 R은 함수가 생성될 때가 아닌, 함수가 실행되었을 때에서야 비로소 값을 찾아 나섬.
# 만약 함수가 함수 외부의 환경에 의존한다면, 함수의 결과가 외부 환경에
# 바인딩된 객체의 변화에 따라 달라질 수 있음.

g12 <- function() x + 1
x <- 15
g12() # global env. 에서 찾은 x 15에 +1

x<-20
g12() # global env.에서 찾는 x 20에 +1
# 이런 것을 lazy evaluation이라고 함.


# g12() 함수는 상위환경인 global variable에 의존하고 있음
# 가급적 이런 코딩은 지양

codetools::findGlobals(g12)
# +와 x라는 함수에 depend 중,
environment(g12) <- emptyenv()
g12()




# 6.5 Lazy evaluation
# 느리게 평가된다. 실행될 때만 값을 찾게 된다.

h01 <- function(x) {
    10
}
h01(stop("This is an error!"))
# 10이 반환됨. h01 함수 안에서는 x를 access하지 않으므로
# stop이 사용되지 않음. 따라서 error 싸인이 사용되지 않음.



# 6.5.1 Promises
# lazy evaluation이 가능하도록 하는 자료구조를 promises라고 함.
# promises는 R 내 함수의 arguments 들이 lazy evaluation하는데 사용되는 R 객체.
# 함수의 arguments 들이 매칭(제대로 들어왔나 확인)되고, 
# 함수의 arguments의 각 값들이 promise에 바인드 됨.

# 3가지 promise 구성 요소
# 표현식, arguments 에 입력된 expression이 저장됨.
# 환경, 함수가 호출됐을 때의 환경 정보가 저장.
# 값, arguments의 값이 조회되기 전까진 비워져있다가
#     body에서 값들이 필요할 때 채워지게 됨.



# 환경
y <- 10
h02 <- function(x) {
    y <- 100
    x + 1
}

h02(y) # y가 함수 내의 env에도, global env에도 등록돼있음. 함수 외의 값 10을 사용함.
h02(y <- 1000) # global env의 y가 1000으로 변경됨.
y

# 값, 필요할 때만 채워짐.

double <- function(x) { 
    message("Calculating...")
    x * 2
}

h03 <- function(x) {
    c(x, x)
}

h03(double(20)) # calculating 메세지가 한 번만 출력됨.
# 첫 번째 x가 accessed 되었을 때, 
# promise에 저장된 expression이 평가됨
# 결과 값이 채워진 후 두 번째 x는 저장된 값을 사용하고
# 더 이상 expression이 평가되지 않게 됨 


# 6.5.2 Default arguments
h04 <- function(x = 1, y = x * 2, z = a + b) {
    a <- 10
    b <- 100
    
    c(x, y, z)
}
h04()

# 디폴트 알규먼트의 문제
x<-y<-z<-5
h05 <- function(x = ls()) {
    a <- 1
    x
}
h05() # h05 환경 내의 a,x 리스트 출력
h05(ls()) # global env. 의 리스트 출력


x_ok <- function(x) {
    !is.null(x) && length(x) == 1 && x > 0
}
x_ok(NULL)
x_ok(1)
x_ok(1:3)



x_ok <- function(x) {
    !is.null(x) & length(x) == 1 & x > 0
}

x_ok(NULL)
x_ok(1)
x_ok(1:3)



# 6.6 ...(dot dot dot)
i03 <- function(...) {
    list(first = ..1, third = ..3)
}
str(i03(1, 2, 3)) # 별로 안 중요... 그래도 이해는 하고 있자.

# 6.7 스스로 해보기
# 6.7.4 Exit handlers는 봐두자.
# on.exit 함수 사용시 함수가 에러가 나든 안나든
# 함수 evaluation이 끝날 때 on.exit에서 지정해둔 액션이 
# 실행되게 만들 수 있고, option인 add=TRUE 는 항상 사용하는게 좋다.
# 함수 내의 워킹디렉토리를 바꿔서 사용하다가
# 함수 사용이 끝나고 나서 다시 원래 워킹디렉토리로 돌릴 때 유용.
# 그 외에도 함수 내에서만 사용하는 옵션 같은 것들에서 유용.
cleanup <- function(dir, code) {
    old_dir <- setwd(dir)
    on.exit(setwd(old_dir), add = TRUE)
    
    old_opt <- options(stringsAsFactors = FALSE)
    on.exit(options(old_opt), add = TRUE)
}


# 6.8 Function forms
# infix
# R에서 모든 것은 객체다
# R에서 어떤 일이 일어나는 모든 것은 함수의 call이다.

# 6.8.3 infix functions
# pipe 연산자와 같은 operator들은 다 함수로 만들어진 것.


# Advanced R : Ch.7
# 7. Environments
library(rlang)

# 환경이 리스트와 구별되는 4가지 사항
# 모든 환경은 이름이 붙어있는 리스트와 비슷하나 차이가 있는 4가지 사항

# 모든 이름은 Unique 해야함
# 환경에 등록된 이름은 순서가 없다. 
# 모든 환경은 상위환경을 가지고 있다.
# 환경들은 카피가 되지 않는다.
# 2번 3번 자세히 살펴보자.



# 7.2.1 Basics 함수
# env()	        rlang	새로운 환경을 생성 또는 부모환경을 지정/ 환경 생성과 동시에 값을 부여할 수 있음
# new.env()	    base	새로운 환경을 생성/ 환경을 먼저 생성한 후 값을 부여해야 함
# env_print()	rlang	환경에 대한 정보를 출력/ 바인딩된 객체 심볼과 종류를 보여줌 / str() 함수와 유사
# env_names()	rlang	환경에 바인딩된 객체를 출력
# names()	    base	환경에 바인딩된 객체를 출력
# ls()	        base	환경에 바인딩된 객체를 출력/ all.names = TRUE 지정할 것을 추천
# identical()	base	환경을 비교하는데 사용
# env_parent()	rlang	부모환경을 확인하는데 사용/ 모든 상위환경들 확인은 last = empty_env() 지정하면 됨
# parent.env()	base	부모환경을 확인하는데 사용
# env_poke()	rlang	한 개의 심볼과 값을 바인드 할 때 사용
# env_bind()	rlang	여러 개의 심볼과 값을 바인들 할 때 사용


# 환경을 만들기 위해서는 rlang::env() 이용.
# list와 비슷한 이유는 각각의 원소에 이름을 붙이거나,
# 객체를 지정할 수 있기에

e1 <- env(
    a = FALSE,
    b = "a",
    c = 2.3,
    d = 1:3,
)

# base 패키지에도 new.env도 있지만 값까지 한번에 넣어서
# 지정하기가 불편. 따라서 rlang::env가 편함.


# 환경의 원소들은 색인(index)되어 있지 않음.
# 즉 원소의 자리 순서라는건 없음.
e1[2] # 이런 subsetting 불가.
e1[[2]] # 역시 불가

# 리스트와 같은 구조이므로 원소 이름을 사용하면
# 한개의 원소를 추출할 순 있으나, 벡터로 여러개는 불가
e1[["a"]] # 가능
e1[["b"]] # 가능
e1[[c("a","b")]] # 불가능
e1["a"] # 불가능
names(e1)

lapply(e1, "[[", 1) #이렇게 하면 정보를 다 볼 수 있음.
lapply(e1, "[", 1) #이렇게 하면 정보를 다 볼 수 있음.


# 환경은 수정 시 modify in flace가 일어남.
# copy-on-modify가 아님.

e1$d <- e1 # 환경은 자기 자신을 포함할 수 있다.

e1
env_print(e1) # 함수의 자세한 정보 알려줌.
env_names(e1); names(e1)

# 7.2.2 Important environments

# current_env() 와, global_env()가 있음.
# current_env()는 현재 코드가 실행중인 환경
# ex) 함수 환경

# global environment는 workspace라고 불림.
# 모든 인터렉티브 계산이 실행되는 환경

current_env()
global_env()

# 함수를 비교할 때는 == 연산자 가능하나,
# 환경 비교시 identical 함수 사용해야 함
identical(global_env(), current_env())



# 7.2.3 Parents
# 모든 환경은 상위환경(부모환경)을 가짐.
# 환경의 상하구조는 Lexical scoping에 사용됨.

e2a <- env(d=4, e=5)
e2b <- env(e2a, a=1, b=2, c=3)
# e2b는 e2a의 하위환경
env_parent(e2b) #e2a가 나옴
env_parent(e2a) #global env.


# empty env는 유일하게 부모환경이 없는 환경.
# 모든 환경 상위환경의 마지막은 empty env.

e2c <- env(empty_env(), d = 4, e = 5)
e2d <- env(e2c, a = 1, b = 2, c = 3)

env_parent(e2d)
env_parent(e2c)
env_parent(empty_env())


# 상위환경 다 보고 싶으면?
env_parents(e2b, last=empty_env())
env_parents(e2b)



parent.env(e2b) #베이스 패키지에서 상위환경 확인할 때 방법
# 한개만 볼 수 있음




# 7.2.4 Super assignment <<-
# super assignment는 parent environment에 객체를 할당시킴.

x <- 0
f <- function() {
    x <<- 1 # 전역환경으로 등록함.
}
f()
x 




# 7.2.5 Getting and setting

e3 <- env(x=1, y=2)
e3$x
e3$z <- 3
e3[["z"]] # 가능
e3[[1]] # 불가
# 객체가 바인딩되지 않으면, 에러 대신 NA 출력하게 해줌.
env_get(e3, "xyz", default = NA)
# 원소 환경에 바인딩 시킬 때 이름 한개 값 하나 할당할 때 사용
env_poke(e3, "a", 100)
# 여러 값을 할당 시킬 때 사용
env_bind(e3, a = 10, b = 20)


# 등록된 원소를 제거 하고 싶으면?
e3$a
e3$a <- NULL
env_has(e3, "a") # 이렇게 해도 안없어지고 살아있음. 값은 없어졌지만

env_unbind(e3,"a")
env_has(e3,"a") # 없어짐
# 객체와 심볼의 바인딩이 없어졌다고, 객체 자체가 메모리에서 없어지는 건 아님.
# 조금 남아있음.






# 7.3 Recursing over environments
# 특정 심볼과 바인드된 객체가 어느 환경에 존재하는지
# 찾아주는 함수를 만들어보자.
# recursive 함수를 사용해서 만들자.

where <- function(name, env = caller_env()) {
    if (identical(env, empty_env())) {
        # Base case
        stop("Can't find ", name, call. = FALSE)
    } else if (env_has(env, name)) {
        # Success case
        env
    } else {
        # Recursive case
        where(name, env_parent(env))
    }
}
# 위 함수는 세 가지 가능한 경우들을 고려하고 있습니다.
# 실패 경우
# 
#   바인딩을 찾지 못하고 empty environment에 도달한 경우
#   오류 메세지를 반환함
# 
# 성공 경우
# 
#   현재 환경에서 심볼이 존재하는 경우
#   현재 환경에 대한 정보를 반환함
# 
# 반복
#
#   현재 환경에서 심볼을 찾지 못하여 상위환경에서 검색을 반복

where("yyy")
x <- 5
where("x")
where("mean")


e4a <- env(empty_env(), a = 1, b = 2)
e4b <- env(e4a, x = 10, a = 11)

env_parent(e4a)
env_parent(e4b)

# e4b의 상위환경 주소와 e4a의 현재 환경 print가 같음.
env_print(e4a)
env_print(e4b)


where("a",e4b)
where("b",e4b)
where("c",e4b)



#
ls()
env_parent(.GlobalEnv)
env_parent(e4a)
env_parent(e4b)


# a는 e4a와 e4b 모두에 등록돼 있으므로 다른게 출력.
# 하위환경부터 찾아가는 걸로 만들었으니까
where("a", e4a) 
where("a", e4b)

# b는 e4a만 있으므로 e4a 환경 주소만 출력
where("b", e4a)
where("b", e4b)

# c는 없음.
where("c", e4b)
library(rlang)
?where

# 7.4 Special environments
# 패키지 환경과 함수환경이 있고,
# 함수환경 안에 실행환경이 있음.

# 7.4.1 Package environments and the search path
# library() 또는 require() 함수를 사용해서
# 탐색 경로에 추가된 패키지는 전역환경(global env)의 상위환경이 됨.

# 패키지를 load하는 것과 attach하는 것은 차이가 있음.
# 패키지에 포함된 함수를 ::으로 사용 시 패키지는 자동 load되지만 탐색 경로에 추가되진 않음.
# 패캐지를 탐색 경로에 추가하게 되면 패키지에 포함된 객체에 전역환경 또는 작업환경에서 접근이 가능해짐.
# 패키지를 load했을 때는 패키지에 포함된 함수를 ::으로 접근 가능하지만
# 전역환경 또는 작업환경에서의 패키지 안의 객체에 접근은 불가능함.


# search path에 구조
# 기본적으로 global env에서 찾고 다음은
# 가장 최근에 추가한(library,require로 부르면 search path에 추가되므로) 
# 패키지, 그 다음은 그 전에 추가한 패키지.
# 마지막은 base, 그다음이 empty env.

search() # 순서대로 확인 가능
search_envs() # 이렇게도 확인 가능

# search path에 추가된 rlang 패키지 환경에 등록된 심볼들 출력
head( ls( pos = 3 ), 10) # pos인자로 순서 찍거나
head( ls( envir =  as.environment("package:rlang"), 10) ) # 이렇게도 가능



# 7.4.2 The function environment
# 함수 환경은 함수가 생설될 때 환경을 의미
# 함수를 구성하는 세가지 요소 : arguments, body, environments
# 함수 환경은 lexical scoping에 사용됨.

# 왜 함수를 closure라고 부르나요?
# 함수가 생성될 때 환경을 enclose, capture하기 때문에 closure라고 부름.
# 함수의 환경은 fn_env() 또는 environment() 사용


# global env 안에 y 심볼과 f 심볼이 있고,
# 함수 f()는 별도의 공간에 만들어져있고
# global env 안의 f 심볼에 바인딩되어 있다.
# 교재 그림 확인
y <- 1
f <- function(x) x+y
fn_env(f)
environment(f)



# 이렇게 만들면 위와 좀 다름
e <- env()
e$g <- function() 1
env_print(e)
env_print(e$g)
# global env안에 e라는 심볼이 있고, 그게 새로운 외부 환경을 바인딩함.
# 새로운 환경 안에 그 안에 g라는 심볼이 들어가 있음.
# g라는 심볼이 새로운 환경 외부에 있는 g() 함수를 바인딩하고있고,
# 그 g() 함수의 요소중 작업 환경(environment) 요소는 Global env임.(이게 중요)
# 함수가 생성될때의 환경이 global env이기에.
# 함수가 e$g를 통해서 생성되어서 심볼은 새로운 환경에 들어가있지만,
# g() 함수가 실행될때 arguments를 찾지 못하면 상위환경인 global env로
# 들어가야되므로..
# 교재 그림 확인



# 7.4.2 Namespaces
# 네임스페이스 환경
# rlang 네임 스페이스에 등록된 심볼은다음과 같이 출력 가능
head( ls( envir = asNamespace("rlang"), 10 ) )
# 네임스페이스 환경이 필요한 이유는?
# 패키지를 추가할 때 순서에 따라 탐색경로가 변할 수 있음.
# 만약 어떤 패키지에 포함된 함수들이 다른 패키지에 포함된 함수를 
# 필요로 한다면 패키지를 추가하는 순서가 중요해짐.
# 이런 문제를 해결하기 위해 네임스페이스 환경을 고안함.
# 얘는 var 함수를 이용하여 정의됨.
# 만약 var() 이라는 동일한 이름의 그러나 다른 연산을 하는 함수가
# 전역환경이나 다른패키지환경에 존재한다면?

dat <- c(3,4,2)
var(dat)
sd(dat)

var <- function(x) sum(x)

var(dat)
sd(dat) # 얘는 새로 바뀐 var에 영향을 받지 않음
# 이게 Namespace 때문.

# search path 에 따르면
# global env 다음 stat패키지(var, sd 함수가 들어있음)
# 새로 만든 이상한 함수 var이 global env에 있으므로
# var을 쓰면 새로만든 이상한 함수로 사용되는것.

# stat 패키지 안의 sd()라는 함수 객체는 namespace:stats 환경에 등록돼 있음.
# namespace:stats 안에는 var함수도 있으므로,
# sd()를 입력하면 global env가 아닌 namespace:stats에서 실행되게 되고,
# sd()가 이용하는 var함수는 똑같이 namespace:stats에서 찾아서 쓰므로,
# var을 이상하게 정의해도 sd()는 영향을 받지 않음.
# 유저가 직접 var을 쓰면, 만들 당시 global env에 등록돼있으므로
# global env부터 쓰니까 var 자체는 이상하게 나옴.
# 교재 그림 참고.

# 즉 sd라는 함수 실행 시의 환경은 namespace에 있고, var도 그안에 있으니까
# var을 이상하게 바꿔도, sd가 사용하는 var은 namespace에서 씀.
# 따라서 sd를 쓰면 정상적인 var을 이용해서 문제가 안생김.
# var을 쓰면 global env에서 만들었으니까 그게 쓰이는거고.



# 7.4.4. Execution environments 
# 함수가 실행될 때 생성되는 환경

h <- function(x) {
    # 1.
    a <- 2 # 2.
    x + a
}
y <- h(1) # 3.

# 함수 심볼 h는 global env 에 등록돼있음.
# 심볼 h는 함수객체를 바인딩하고 있음.
# 또한 함수객체 h의 환경은 global env.
# 함수가 실행될 때 execution env가 새롭게 생성됨.
# 그 execution env는 함수객체를 바인딩.
# 그 execution env 안에 x라는 심볼이 1을 바인딩하고 있음.
# 그 다음 그 execution env안에 a가 생성돼서 2를 바인딩.
# 계산된 y는 전역환경에 들어가고, 3을 바인딩하고,
# a와 x는 없어짐.
# 즉 실행 시 필요한 변수 x, a는 exe env에서 잠깐 생겼다가
# 쓰이고 없어지고, y만 global env에 남음.
# 교재 그림 참고
a
x



library(rlang)
h2 <- function(x) {
    a <- x * 2
    current_env()
}
e <- h2(x = 10)
unlist(lapply(e,"[[",1))
env_print(e) 
# h2의 return값인 현재환경은 execution env임.
# 따라서 env_print(e)하게 되면 execution env 주소가 출력됨.




plus <- function(x) {
    function(y) x + y # function(y) 1+x 와 같음.
}
plus_one <- plus(1)
plus_one
plus_one(2)
# plus() 함수의 반환되는 객체는 함수임
# plus_one() 함수는 plus() 함수의 exe env에 등록된 x를 사용함.
# 교재 그림 참고


