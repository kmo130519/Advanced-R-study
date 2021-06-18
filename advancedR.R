#전산통계 2
#Hadley wickham [Advanced R]



# Ch.2 Names and Values (Symbols and Objects)
# 2.1 introduction

library(lobstr)

# 사용할 주요함수
# obj_addr(x) -> 객체 x가 참조하는 메모리 주소를 출력
# tracemem(x) -> 객체 x가 메모리 상에 복제가 일어날 때 알려줌
# ref(..., character=F) -> 데이터 내의 원소가 참조하는 메모리 주소 알려줌
# obj_size(..., env = parent.frame()) -> size를 계산해줌

x <- c(1,2,3) # 객체 c(1,2,3)을 x에 할당한다라고 표현해야 한다. x라는 심볼 또는 이름을 객체에 할당한다.
# 즉 1,2,3 이라는 객체가 특정 메모리 주소에 할당이 되고, 심볼 x(name) 이 1,2,3 값에 대한 참조가 된다.(가리키고 있다), 객체에 할당된다.

y <- x #라고 하면, 1,2,3 의 주소에 x,y 심볼이 1,2,3 객체에 바인딩 된다. x,y(name, symbol)이 1,2,3 객체를 같이 가리키게(pointing) 된다.
# 즉 y라는 벡터를 생성한다고 얘기할 수 없다. 동일한 값을 참조하고 있게 된다.

obj_addr(x)
obj_addr(y) # x,y 가 참조하고 있는 객체, 메모리 주소가 같다.




# 2.2.1 Non-syntatic names

# R의 객체명 규칙
# 문자, 숫자, .,_ 로 구성 가능
# _또는 숫자로 시작할 수 없다
# .으로 시작하게 되면 다음에 문자가 와야한다.
# 예약어는 사용할 수 없다.
# backtick ` 기호를 사용하면 규칙을 무시하고 사용할 수 있다.

# 총정리 : 문자나 온점으로만 시작해야하며, 온점으로 시작시 다음에 문자가 와야한다. 사용가능한 기호는 언더바밖에 없다.





# 2.3 Copy-on-modify

x <- c(1,2,3)
y <- x

# 같은 객체를 가리키고 있는 심볼 x,y 할당

y[3] <- 4

x # 출력 시 변환되어 있지 않음. y의 원소를 바꾸려고 할 때 심볼 y에 할당된 객체가 복사가 되어 y에 할당이 되고, 복사된 객체의 원소가 바뀐다.
  # x가 참조하고 있는 객체의 원소를 바꿔도 마찬가지다. x[3] <- 4

# Copy-on-modify 를 어떻게 확인할 수 있을까?
# tracemem() 사용

x <- c(1,2,3)
cat(tracemem(x), "\n")

y <- x
y[3] <- 4L

untracemem(x) # 객체 복사 추적 마침.

x <- c(1,2,3)
y <- c(1,2,3)
obj_addr(x)
obj_addr(y) # 이렇게 할당하면 메모리 주소가 각각 다르다.






# 2.3.2 Function calls
# 함수 호출 시에도 동일한 복사 규칙이 적용된다.

f <- function(a) {
    a
}

x <- c(1,2,3)
cat(tracemem(x), "\n")

z <- f(x)

class(z) # f 함수에 x를 인자로 실행. z는 numeric
class(f) # f 는 함수
z[[1]] <- 6 # 심볼 z로 참조하고 있는 객체 1,2,3 의 메모리 주소를 바꾸면, x가 point하고 있던 곳에서 copy on modify 된다.

untracemem(x)

# 함수 f 가 호출되어 실행될땐 실행환경이 생겨서, 실행될 때 사용된 인자값이 실행환경 내에 할당된다. z <- f(a=x). 그럼 x가 바인딩돼있는 객체 1,2,3을 z도 바인딩하게 된다.




# 2.3.3 Lists 
# 리스트의 원소들은 값들 자체가 아닌, 값들을 가리키는 참조들을 원소로 포함하고 있다.

l1 <- list(1,2,3) #리스트 틀이 메모리 주소에 할당 되고,그 메모리 주소의 리스트 틀 안에는 원소들을 가리키는 참조들을 원소로 포함하고 있다.

l2 <- l1 # 원소 1,2,3의 참조 주소들을 틀 안에 저장하고 있는 메모리 주소를 l1, l2가 같이 바인딩한다.

l2[[3]] <- 4 # shallow copy. 원소 세개가 가리키는 참조가 카피 되지만, 마지막 원소의 참조주소만 바뀐다. 교재 그림 참고.
# 리스트 객체와 참조들은 복사가 되지만, 참조들이 가리키는 값들은 복사가 되지 않음.

ref(l1, l2)



# 2.3.4 Data Frames
# 동일한 길이를 갖는 원자 벡터들로 이루어진 리스트
d1 <- data.frame(x=c(1,5,6), y=c(2,4,3))
d2 <- d1
d2[,2] <- d2[,2]*2 # 틀 자체는 copy가 돼서 생겨남. 원소들(원자벡터들, 데이터프레임이니까)이 가리키는 각각 참조들도 복사가 되지만, 두번째 열(원소벡터)는 새로운 주소를 갖게 된다.

# 행을 바꾸면?

d3 <- d1 
d3[1,] <- d3[1,] *3 # 객체 d1,d3가 바인딩하고 있던 메모리가 같지만, 모든 열이 영향을 받아 원소들이 가리키는 참조값이 다 바뀐다.

ref(d1,d3)


# 마지막으로 데이터프레임은 원소를 재지정 할 때 마다 두 번 복제가 일어난다.
d1 <- data.frame(x = c(1,5,6), y=c(2,4,3))
tracemem(d1)

d2 <- d1
d2[,2] <- d2[,2] *2

untracemem(d1)
# 두번 복제가 일어나므로 루프를 데이터프레임에 돌리면 리스트보다 느려진다.


x <- data.frame(matrix(runif(5 * 1e4), ncol=5))
medians <- vapply(x, median, numeric(1))
cat(tracemem(x), "\n")


for(i in seq_along(medians)) {
    x[[i]] <- x[[i]] - medians[[i]]
} # 총 열번의 복제가 일어난다.


#반면에 리스트를 사용하면?

y <- as.list(x)
cat(tracemem(y), "\n")

for(i in seq_along(medians)) {
    y[[i]] <- y[[i]] - medians[[i]]
} #복제가 한 번 일어남.

untracemem(x)
untracemem(y)



# 2.3.5 character vectors
# 문자형 벡터는 효과적인 메모리 관리를 위해 다른 방법 사용, 문자열을 전체로 통합해서 관리, 중복 없이 집합을 만듦.(pool)
# R은 전역 문자열 집합(global string pool)을 사용. 문자형 벡터의 각 원소는 이 집합(pool)안에 중복됨 없이 포함된 문자열을 가리킨다.

x <- c("a","a","abc","d") # global string pool 안에는 a는 한번만 들어가 있음. 문자열 원소 4개에는 global string pool을 가리키는 참조값들이 들어있음.

ref(x, character=T)




# 2.4 Object size
#obj_size()

obj_size(letters)

# 리스트의 원소들은 값들에 대한 참조들이므로 리스트의 크기는 생각만큼 크지 않다.
x <- runif(1e6)
obj_size(x)

y <- list(x,x,x)
obj_size(y)

# x,y의 크기는 80bytes 차이밖에 안난다. 세배차이가 아님.
# 80바이트 크기는 세개의 NULL원소를 포함한 리스트의 크기가 80byte임.
obj_size(list(NULL,NULL,NULL))


# 즉 문자열을 백번 반복한다고 백 배 사이즈가 커지는 것이 아님.
# 객체 x와 객체 y의 크기가 같은 것은 x와 y의 원소가 동일한 것이 하나도 없을 때 성립한다.
# R 3.5.0 이후에 나온 버전에서는 ALTREP, short for alternative representation 기능을 사용한다.

obj_size(1:3) == obj_size(1:1000) # 첫 숫자와 끝 숫자만 기억하므로.





# 2.5 Modify-in-place
# R은 copy-on-modify 규칙을 따르지 않는 두 가지 예외적인 경우가 있다.
# 1. 한 개의 심볼에만 할당된 객체들.
# 2. 환경

#1.
v <- c(1,2,3)
v[[3]] <- 4

#2.
e1 <- rlang::env(a=1, b=2, c=3)
e2 <- e1


e1$c <- 4
e2$c

ref(e1)
ref(e2) #copy-on-modify가 일어나지 않음.


################# 과제 ######################

# 2.2.2 exercises
# 1. 
# 숫자 열로 생성 연산자 콜론을 사용했으므로, 1과 10만이 저장됨. 심볼 a,b,c는 같은 곳을 참조하게 된다. 
# 그러나 d 객체는 새롭게 할당된 것이므로 a,b,c처럼 1과 10만을 저장하지만, 다른 메모리 주소를 참조한다.
a <- 1:10
b <- a
c <- b
d <- 1:10


ref(a) == ref(b) # true
ref(b) == ref(c) # true
ref(d) == ref(c) # false

# 2. 
#같은 객체를 가리키고 있다.
c(
obj_addr(mean),
obj_addr(base::mean),
obj_addr(get("mean")),
obj_addr(evalq(mean)),
obj_addr(match.fun("mean"))) %>% unique()

# 3.
# R에서 데이터를 불러올 때 명명 규칙에 맞지 않는 것은 자동으로 명명 규칙에 맞게 변환한다.
# 그러나 자동으로 변환되는 것이 손실되면 안되는 데이터일때는 check.names 인자를 FALSE로 설정하면 가능하다.


# 2.3.6 exercise
#1.
tracemem(1:10) 
# tracemem 함수는 객체가 copy될 때 추적해서 출력해준다. 
# 허나 1:10은 심볼이 바인딩되지 않았으므로 copy에 부적합하다.


#2.
x <- c(1L, 2L, 3L)
tracemem(x)

x[[3]] <- 3

# class(x)를 원소를 바꾸기 전에 출력해보면 integer형으로 명시가 되어있으나
# integer로 명시해주지 않은 4 값이 들어가면서 copy-on-modify가 일어난다.

#3. 
a <- 1:10
b <- list(a, a)
c <- list(b, a, 1:10)

# 첫줄에서는 1:10 객체에 심볼 a가 바인딩된다
# 두번째 줄에서는 list로 (a,a)를 할당했으므로 객체 a의 메모리주소를 reference하며, 그 주소가 원소로 들어가 있을 것이다.
# 세번째 줄에서 또한 list로 할당했으므로 첫번째 원소로 지정된 b는 객체 b의 주소를 reference하며, 두번째 원소 a는 객체 a의 주소를 가리키고 있으며, 세번째 원소 1:10은 새로 메모리에 할당되고, 그 곳의 주소를 reference하게 된다. 


#4.
x <- list(1:10)
x[[2]] <- x
# x[[2]]는 원래 없으므로 NULL값이 출력된다. x[[2]]에 x를 할당하면서 두 개의 주소를 참조하고 있는 두 칸의 메모리가 새로 할당된다.
# 첫번째 칸은 기존의 1:10 객체를 참조하면서 두번째 칸은 기존 x가 참조하고 있던 메모리 주소를 참조하게 된다.
# 그 두칸의 메모리로 x라는 이름이 다시 바인딩 된다.




# 2.4.1 excercise
#2.
funs <- list(mean,sd,var)
obj_size(funs)

# R에 이미 기본적으로 내장되어 있는 함수들의 크기를 측정하는 것이므로 


#3.
a <- runif(1e6)
obj_size(a)
# double형식은 8byte를 차지하므로, 8백만 byte에 빈 벡터 할당 값 48byte가 더해져 8,000,048 byte가 된다



b <- list(a, a)
obj_size(b)
obj_size(a, b)
# b 리스트의 원소는 a의 주소를 참조하게 되므로 새로운 메모리는 필요없게 된다.
# 두 개의 빈 리스트 메모리 (64byte)만 필요로 하게 되며, a 객체의 메모리를 포함한 8,000,112 byte가 된다.
b[[1]][[1]] <- 10
obj_size(b)
obj_size(a, b)
# b의 첫번째 원소 값을 수정했으므로 copy-on-modify가 일어난다.
# 두번째 원소만 a 객체를 참조하고 있고, 첫번째 원소는 새로 할당된다.
# 따라서 8,000,048 * 2 + 64(두 칸의 빈 리스트)


b[[2]][[1]] <- 10
obj_size(b)
obj_size(a, b)
# b 리스트의 두번째 원소 값이 바뀌므로 copy-on-modify가 일어난다.
# size에는 영향을 주지 않으나 더이상 a객체를 참조하고 있는 원소는 없다.



# 2.5.3 excercise
#1.
x <- list()
x[[1]] <- x

# 두번째 줄에서 copy-on-modify가 일어난다. 그러나 첫번째 원소는 x를 여전히 참조하고 있다.

#2.
library(bench)

create_random_df <- function(nrow, ncol) {
    random_matrix <- matrix(runif(nrow * ncol), nrow = nrow)
    as.data.frame(random_matrix)
} # 행, 열 수를 설정하면 랜덤으로 원소 값을 uniform dist.를 이용해서 랜덤으로 생성


subtract_df <- function(x, medians) {
    for (i in seq_along(medians)) {
        x[[i]] <- x[[i]] - medians[[i]]
    }
    x
} # 데이터프레임 자료형에서 각 원소에서 median 값을 빼줌

subtract_list <- function(x, medians) {
    x <- as.list(x)
    x <- subtract_df(x, medians)
    base::list2DF(x)
} # 리스트형으로 자료형 변환 후 median 빼줌


benchmark_medians <- function(ncol) {
    df <- create_random_df(nrow = 1e4, ncol = ncol)
    medians <- vapply(df, median, numeric(1), USE.NAMES = FALSE)
    
    bench::mark(
        "data frame" = subtract_df(df, medians),
        "list" = subtract_list(df, medians),
        time_unit = "ms"
    )
} # create_random_df 함수를 이용해서 만개의 행을 고정 시킨후 열 수를 인자로 둠.
# 미디안을 계산한 후 위에서 만든 데이터프레임, 리스트의 형에서 각각 함수 실행
# bench패키지의 mark를 이용해서 시간을 확인

results <- bench::press(
    ncol = c(1, 10, 50, 100, 250, 300, 400, 500, 750, 1000),
    benchmark_medians(ncol)
)
#results에 열수를 1부터 1000까지 늘려가면서 실행한 결과를 할당.

library(ggplot2)

a <- ggplot(
    results,
    aes(ncol, median, col = attr(expression, "description"))
) +
    geom_point(size = 2) +
    geom_smooth() +
    labs(
        x = "Number of Columns",
        y = "Execution Time (ms)",
        colour = "Data Structure"
    ) +
    theme(legend.position = "top")
a
# 두 함수를 범주로 두고 시각화.
# 리스트보다 데이터프레임이 복제가 많이 일어나므로 loop연산에서 열 수가 늘어날수록 훨씬 많은 시간이 소요됨을 알 수 있다. 

#3.
#환경의 경우 복사를 하지 않고 수정이 이루어진다. 따라서 tracemem 함수 사용시 에러가 발생한다.



#
##############################################











# Advanced R Ch.3

# 3.1 Introduction

# R에서 벡터가 왜 가장 중요한 자료구조 유형일까.
# 원자 vector 를 통해 matrix, list ... 등을 만들어내기 때문이다.

# 벡터에는 atomic 벡터와 lists가 있다. 둘의 차이는 원소의 유형에서 결정된다
# atomic vector는 자료의 유형이 한가지로만 채워지는 것.
# lists는 자료의 유형이 여러개일 수 있다.


# attribute란 무엇인가.  => metadata, 우리가 가지고 있는 자료에 대해 설명 해주는 것. 이름하고 값이 pairing된.
# vector 에는 두가지 중요한 속성이 있다. dimension and class. ( dim() / class() )
# dim() 은 S3 method. 인자로 들어온 객체에 대하여 class 를 파악하고 해당하는 출력을 내어주는 것.
# atomic vector에 dimension을 부여하면 matricx나 array를 만들 수 있다.






# 3.2 Atomic vectors

# logical, integer, double, character, complex, raw 등의 종류가 있다.
# typeof() / mode() 등의 함수를 사용하여 형을 확인할 수 있다.
# 다만 mode() 함수는 integer와 double형을 하나의 numeric형으로 취급한다.




# 3.2.1 Scalars

# R에는 scalar 자료 유형이 존재하는가?
# scalar라는 엄밀한 형 구분은 없고, vector의 원소 개수가 1개인 경우 비슷하게 생각할 수는 있으나 형은 vector이다.

x <- c(1,2,3)
typeof(x)
mode(x)

x <- c(1L,2L,3L)
typeof(x)
mode(x)


x <- c(1,"1")
typeof(x)
mode(x)

y <- 1:3  # : 를 이용하면 기본형을 double이 아닌 integer로 들어감.
typeof(y)

y[3] <- 3 # integer에서 double이 바뀜.
typeof(y)





# 3.2.2 Making longer vectors with c()

lgl_var <- c(TRUE, FALSE)
int_var <- c(1L, 6L, 10L)
dbl_var <- c(1, 2.5, 4.5)
chr_var <- c("these are", "some strings")



c(c(1,2),c(3,4)) # combine 은 항상 1차원 구조기에 의미 없음.







# 3.2.3 Missing values

# Missing values tend to be infectious
# NA로 표현됨

NA > 5
10 * NA
!NA # 마치 전염된 것처럼.

# a few exception cases these rules, occur when some identity holds for all possible inputs:

NA ^ 0
NA | TRUE
NA & FALSE


x <- c(NA, 5, NA, 10)
x == NA
# NA라는 값은 어떤 값을 가질지 모르는 미정된 상태, 따라서 x vector 와 비교해서 결정할 수 없다.
# 따라서 NA == NA라는 비교문 자체가 이상한 것. 미정된 것끼리의 비교

# NA의 index를 확인하고 싶을 때는
is.na(x)


NA_integer_
NA_real_ # double
NA_character_

# 미정된 NA의 형 정도는 미리 결정해줄 수 있다는 것.

typeof(NA_integer_)
typeof(NA_real_)
typeof(NA_character_)
typeof(NA_complex_)

# 우리가 그동안 사용하던 NA는 default가 논리형이었던 것.
# 왜 그렇게 했을까?
# 그다지 중요하지 않기에. coerced. 강제 형변환이 일어날 때 가장 유연한 형이기에 그렇기도 하다.



# Testing and corecion
# is.logical(), is.integer(), is.double(), is.character()

int_var <- c(1L,6L,10L)
typeof(int_var)
is.integer(int_var)

typeof(dbl_var)
is.double(dbl_var)

is.atomic(dbl_var)


# is.vector(), is.atomic(), is.numeric() 중요!
# is.vectr() 함수는 객체가 벡터형인지 확인하는 함수가 아니다.
# vector에는 atomic vector와 list가 있다.
# 벡터가 속성값을 가지고 있지 않을 때(이름(names) 외에!, 이름은 가져도 됨.) TRUE를 반환해주는 함수다.
# names 는 벡터의 원소에 이름을 지정해주는 (like colnames..) 것이므로 상관 x
# 그러나 names 와 name 은 다르고, name을 바꾸게 되면 is.vector()는 false를 반환한다.
x <- c(1,2,3)
is.vector(x)


y <- c(a=1, b=2,c=3)
is.vector(y)


z <- y
attr(z, "name") <- "special my vector"
str(z)
is.vector(z)


z <- y
attr(z, "name") <- "special my vector"
str(z)
is.vector(z)




int_var;dbl_var
is.numeric(int_var)
is.numeric(dbl_var)
# int와 double형은 모두 numeric이다. 


check.vector <- function(x) is.atomic(x) || is.list(x)
check.vector(z) #우리가 형으로 생각하는 vector의 확인함수는 위와 같이 정의하여야 한다.



# atomic이란? => 모든 원소가 same type 
str(c("a",1))
# corecion이 일어남. 우선순위는 character(1) -> double(2) -> integer(3) -> logical(4) 순
# 메모리와 연관. 가장 flexible한 걸로 바꾸기 위해.



# coercion은 언제 일어나는가?

x <- c(FALSE, FALSE, TRUE)
as.numeric(x) # 강제 변환 일어남. FALSE -> 0, TRUE -> 1
sum(x) # total number of TRUEs
mean(x) # Proportion thar are TRUE
as.integer(c("1","1.9","a")) # warning. a는 NA로 처리함. 1.5는trim해서 1로 내림해버림.
as.logical(c("1","1.9","a"))
as.double(c("1","1.9","a"))



# 3.3 Attributes
# atomic vector는 중요한 기본 자료형이지만, matrices나 arrays, factor나 date-times와 같은 형은 포함하지 않는다.
# 그럼에도 중요한 이유는 위와 같은 다른 자료형들을 만들 때 
# atomic vector에서 attributes를 추가해서 만들기 때문에 atomic vector는 기본이 되는 재료 정도로 이해하면 좋다.




# 3.3.1 Getting and setting
# attr()은 name-value pairs. 객체에 메타정보를 추가한 것. 이름-밸류 형태로.


a <- 1:3
attr(a, "x") <- "abcdef"
attr(a, "x")
attr(a, "y") <- 4:6
str(attributes(a))


a <- structure(
  1:3,
  x = "abcdef",
  y = 4:6
  )

str(attributes(a))

# structure() 함수를 이용하면 a를 생성할 때 attr들을 한번에 설정할 수 있다.
# attributes(객체명) 함수로 객체에 setting된 속성들을 get할 수 있다.
# str(attributes(객체명)) 하면 list로 반환되는데, name-value paired 형태기 떄문에 그렇다.

# attributes 는 쉽게 휘발된다. (쉽게 사라진다., 잃는다.)

attributes(a[1])
attributes(sum(a))

# names와 dim 정보는 남아있는 경우가 많다.
# S3 클래스로 만들어서 부여해놓으면 속성이 유지된다.






# 3.3.2 Names
# 벡터에 원소에 이름을 붙이는 방법

# 1
x <- c(a=1, b=2, c=3)

# 2
x <- 1:3
names(x) <- c("a", "b", "c")

# 3
x <- setNames(1:3, c("a","b","c"))

getwd()


# attr(x, "names")로 객체명을 부여하는 것은 지양하자. names를 사용하자.

# 벡터의 원소에 붙은 이름 제거 방법
names(x) <- NULL; x

x <- unname(x)





# 3.3.3 Dimensions            
# 2-dimensional matrix, array로 만들 수 있다.



x <- matrix(1:6, nrow=2, ncol=3)
x


y <- array(1:12, c(2,3,2))
y


# 벡터에 dim attr 추가
z <- 1:6
dim(z) <- c(3,2)
class(z)

# 부여되어있는 dim 속성을 NULL을 넣으면 z객체는 벡터로 바뀜.
dim(z) <- NULL
z



# vector / matrix / array
# names() / row or colnames() / dimnames()
# length() / nrow or ncol / dim()
# c() / rbind() or cbind() / abind::abind()
# 불가능 / t() transpose / aperm()
# is.null(dim(x)) / is.matrix(x) / is.array()




# 어떤 객체가 벡터인지 dim 속성을 사용하여 확인하려면?
z <- c(a=1, b=2, c=3)
attr(z, "name") <- "my special vector"
is.null(dim(z)) #is.vector() 사용이 아닌, dim 속성이 없는가로 확인

matrix(1:3, ncol=1)
str(matrix(1:3, ncol=1))
class(matrix(1:3, ncol=1))
dim(matrix(1:3, ncol=1))

# 3.4 S3 atomic vectors
# factor 형은 integer vector을 기초로 한다.
# Date 벡터는 date를 나타내기 위해
# Date-times 를 나타내기 위해 POSIXct vector를 기초로 함. (ct = calender time)
# Duration을 나타내기 위해 difftime vector 를 기초로 함.


read.csv("csv.csv")


# 3.4.1 Factors
# factor는 벡터인데, 미리 지정된 값들만 가질 수 있는 벡터. class는 factor, levels 라는 attr(속성)을 가질 수 있다.
# integer 벡터와의 차이는 levels 속성을 가지고 있다는 것과 class 가 있다는 두가지 차이가 있다.


# factor는 수치형 벡터를 기반으로 만들었으나 integer는 아님.

x <- factor(c("a","b","b","a"))
x


typeof(x)
attributes(x)


sex_char <- c("m","m","m","f")
sex_factor <-factor(sex_char, levels=c("m","f"))
table(sex_char)
table(sex_factor)



grade <- ordered(c("b","b","a","c", levels=c("a","b","c"))) # 순서가 있는 factor로 생성.

cbind(sex_factor)
grep("m",sex_char) # 사용하는데 문제없음. 원래 스트링벡터니까
grep("m", sex_factor) # 원래는 error가 떠야함. 강제형변환이 된 것. character vector로 바꾼다음에 실행된것


# factor는 연산하려면 일단 character vector로 바꾼 다음 하려는 것을 해라! 중요!







# 3.4.2 Dates

today <- Sys.Date()
typeof(today) # 자료형이 double에 기반하므로
 
attributes(today) # date 클래스


date <- as.Date("1970-02-01")
unclass(date) # 기준점이 1970년 1월 1일이기에 그날로부터 경과 일수
unclass(today) # 기준점으로 부터 오늘까지의 경과 일수





# 3.4.3 Date-times
# POSIXct, POSIXlt로 처리. 졸 POSIXct 사용

now_ct <- as.POSIXct("2018-08-01 22:00", tz="UTC")
now_ct
typeof(now_ct) # double을 기반으로 함
attributes(now_ct) # attr은, class는 POSIX, timezone 은 UTC 
# double벡터와 다른 두가지의 attr 속성 class, timezone

structure(now_ct, tzone = "Asia/Tokyo")
structure(now_ct, tzone = "America/New_York")
# 그리니치 천문대가 표준시의 기준. => UCT
# KST는 UTC에 9시간을 더한 것과 같음





# 3.5 Lists
# 3.5.1 Creating
# list() 함수로 사용
# obj_size() 각각의 원소가 레퍼런스값을 가지므로 싸이즈도 별로 크지 않다
# recursive하므로 list를 중첩으로 사용 가능

l4 <- list(list(1,2),c(3,4))
str(l4)
l5 <- c(list(1,2),c(3,4))
str(l5)







# 3.5.2 Testing and coercion
# as.list 사용 강제 변환
# 리스트 객체는 unlist() 함수를 사용해서 atomic vector로 만들 수 있다. as.vector()로는 바꿀 수 없다.
# list는 벡터니까, 벡터를 벡터로 바꾸라고 하는 꼴.
as.vector(l4)
unlist(l4)







# 3.6 Data frames and tibbles
# 데이터프레임이나 티블 둘 다 리스트이다.
df1 <- data.frame(x=1:3, y=letters[1:3])
typeof(df1) # 리스트에 기초한 자료형

attributes(df1) # 데이터 프레임은 names와 class와 row.names 세가지 속성을 가진다.
# 리스트를 데이터 프레임으로 바꿀 땐 원소 갯수가 각각 같아야 하며, 위 세가지 속성이 있어야 함.




# 데이터 프레임의 특성! 중요!
# 자료를 읽을 때, default는 stringAsFactors = T 이다. 팩터형으로 바꿔지는게 분석용도에 맞기에 자동으로 바뀜.

df1 <- data.frame(
  x = 1:3,
  y= c("a","b","c"),
  stringsAsFactors = FALSE
  )
str(df1)

# 티블은 stringsAsFactors 와 같은 강제변환이 일어나지 않음.




# 3.6.4 Subsettin 중요!
data("mtcars")
dat <- mtcars
typeof(dat[,1]) # 원자벡터로 강제변환 됨. double로 출력

typeof(dat[,1, drop=FALSE]) # 데이터프레임 상태 유지 되면서 list로 출력

names(dat)

dat$m #m만 지정해도 출력돼서 나옴.




# 3.7 NULL
typeof(NULL)
is.null(NULL)
c() # empty vector 만듦.











# Ch4. Subsetting
# 원소추출
# 왜 원소 추출은 필요한가
# [[, [, $.


# 4.2 Selecting multiple elements
# 4.2.1 Atomic Vectors

x <- c(2.1, 4.2, 3.3, 5.4)
x[c(3,1)]
x[order(x)]
x[c(1,1)]
x[c(2.1, 2.9)] #정수로 truncate됨.
x[-c(3,1)]
x[c(-1,2)] # 섞어서 사용 불가
x[c(T,T,F,F)] # true 해당 인덱스만 출력됨
x[x>3]

# 주의 recycling rules

x[c(T,F)] # 로지컬로 인덱싱할때는 T,F가 반복되어 T,F,T,F로 됨.
x[c(T,T,NA,F)]


x[]
x[0] # index에 0을 넣으면 numeric(0)이 생성된다


(y <- setNames(x, letters[1:4]))

y[c("d","c","a")]
y[c("a","a","a")]

# 부분 매칭은 허용 되지 않는다.
z <- c(abc=1, def=2)
attributes(z)
is.atomic(z)
z[c("a","d")] # 불가능
z$abc

y[factor("b")] # y["b"]가 되지 않음. 첫번째 a원소가 출력됨. 즉 factor("b")가 1로 됨, factor는 integer기반.
str(factor("b"))
factor(c("b","c","c","b"))
str(factor(c("b","c","c","b")))
y[factor(c("b","c","c","b"))] # 1,2,2,1원소가 출력됨. 즉 level 에 할당된 integer값으로 indexing



# 4.2.2 Lists
# atomic vector와 동일한 방식
# [] 하나만 사용하면 항상 list 반환, [[]]이나 $를 쓰면 리스트의 요소를 출력한다.

# 4.2.3 Matrices and arrays
# 고차원 구조로도 추출할 수 있다.
# 1. 여러개의 벡터를 이용
# 2. 싱글벡터로
# 3. 매트릭스로

# 1. 여러개 벡터로 추출
a <- matrix(1:9, nrow=3)
colnames(a) <- c("A","B","C")
a[1:2,]

a[c(TRUE,FALSE,TRUE), c("B","A")]

a[0,-2]


class(a)
class(a[1,]) # 1x3 matrix가 아니라 vector임.
class(a[1,1])
class(a[1,,drop=F]) # matrix가 유지됨. 

# 2. 싱글벡터로
# matrices는 arrays는 vector로 볼 수 있음. dim 속성이 부여된 vector

vals <- outer(1:5,1:5, FUN = "paste", sep=",")
vals[c(4,15)] # 행, 열 지정없이 원 디멘젼으로 함. 벡터로 생각해서 4번째, 15번째


# 3. matrix로

select <- matrix(ncol=2, byrow = T, c(
  1,1,
  3,1,
  2,4
))
select
vals[select]




# 4.2.4 Data frames
# 데이터 프레임은 리스트와 매트릭스의 두 가지 성격을 모두 갖고 있다.

df <- data.frame(x=1:3, y=3:1, z=letters[1:3])

df[df$x ==2,] # F,T,F 일테니까 2행만 출력
df[c(1,3),]
df[c("x","z")] # list처럼
df[,c("x","z")] # matrix처럼


str(df["x"]) # 데이터프레임 형 유지
str(df[,"x"]) # 데이터프레임이 아닌 1차원 atomic vector로 simplyfy해버림.



# 4.2.5 Preserving dimensionality
# Use drop=F

# factor에서는 drop 인자의 의미가 다르다.
# 디멘젼이 아닌 레벨과 연관이 있다.
z <- factor(c("a","b"))
z[1] # drop이나 simplify되지 않음.
z[1,drop=T] # 해당되는 원소의 level만 남아있고 b레벨만 simplify됨.
# 굳이 범주를 드랍할거면 뭐하러 factor를 쓰겠어. character 벡터를 쓰면 되잖아!




# 4.3 Selecting a single element

# 4.3.1 [[ 의 사용
# 리스트 객체에 [와, [[ 사용 시 반환되는 객체의 차이점은?
# [ 사용 시 list로 반환
# [[ 사용 시 원소 자체 출력


x <- list(1:3, "a", 4:6)
str(x[1]) # list
str(x[[1]]) # int
str(x[1:2]) # 안에 어떤 인덱싱을 하든 싱글 []을 사용하면 무조건 리스트 반환
x[[c(1,2)]] # x[[1]][[2]] 와 같다




# 4.3.2 $
# x$y == x[["y"]] roughly equivalent

var <- "cyl"
mtcars$var # 사용 불가
mtcars[[var]] # 사용 가능, numeric으로 반환 더블이니까.
vars <- c("mpg","cyl","disp")
head(mtcars[[vars]], n=5) # 더블로 사용하면 당연히 안됨.
head(mtcars[vars], n=5) # 데이터 프레임 유지
str(mtcars["mpg"]) # 데이터 프레임 유지
str(mtcars[["mpg"]]) # 형 유지 안됨.


# $은 부분매칭을 허용하나, [[]]은 부분 매칭 허용 안함.
x <- list(abc=1)
x[["a"]] # 허용 안됨
x$a # 허용

names(mtcars)
mtcars$"m" # mpg 컬럼이 출력된 것
mtcars$"c" # c로 시작되는 것이 한 개 이상이므로 출력 x
mtcars$"cy" # cyl로 출력. 즉 부분매칭은 유일성이 보장돼야 함.



# 4.3.3 missing and out of bounds(인덱스 벗어났다는 뜻)indices
# 교재 표 참고

logical()[[NULL]]
logical()[[1]]
logical()[["x"]]
logical()[[NA_real_]]

list()[[NULL]]
list()[[1]]
list()[["x"]]
list()[[NA_real_]]



# 4.3.4 @ and slot()
# S4 objects 에서 공부할 것.



# 4.4 subsetting and assignment

x <- 1:5
x[c(1,2)] <- c(101,102)


x <- list(a=1, b=2)
x["b"] <- NULL
x[["b"]] <- NULL
str(x) # NULL 값을 할당하면 원하는 키밸류 전체 지울 수 있음.



y <- list(a=1, b=2)
y["b"] <- list(NULL)
str(y) # 위와 다른 결과, b키 값의 밸류만 NULL됨.




mtcars[] <- lapply(mtcars, as.integer)
is.data.frame(mtcars) # []을 썼으므로 데이터 유형이 인티저로 바뀌어도
# 데이터프레임 형태 유지


mtcars <- lapply(mtcars, as.integer)
is.data.frame(mtcars) # 데이터프레임 형태 유지 안됨.




# 4.5.1 lookup tables
# character subsetting

x <- c("m","f","u","f","f","m","m")
lookup <- c(m="male", f="Female", u=NA)
lookup[x]

unname(lookup[x]) # m,f,u를 바꿀 때 유용




grades <- c(1,2,2,3,1)
info <- data.frame(
  grade = 3:1,
  desc = c("Excellent","Good","Poor"),
  fail = c(F,F,T)
)

id <- match(grades, info$grade) # grades가 info$grade의 몇번째에 인덱스가 맞는지
info[id,]





grades <- data.frame( grade = c(1,2,2,3,1))
info <- data.frame(
  grade = 3:1,
  desc = c("Excellent","Good","Poor"),
  fail = c(F,F,T)
)

merge(grades, info) # 공통 컬럼으로 자동 join





# 데이터프레임에서 컬럼을 제외할땐 null 넣던지 setdiff 사용


# 4.5.8 Boolean algebra versus sets(logical and integer)

x <- sample(10) < 4
which(x) # TRUE에 해당하는 인덱스만

unwhich <- function(x,n) {
  out <- rep_len(FALSE,n)
  out[x] <- TRUE
  out
}
unwhich(which(x),10)


x1 <- 1:10 %% 2 ==0
x2 <- which(x1) # 이런식의 인덱싱도 가능


x <- 1:4
y <- c(T,F,T,T)
x[which(y)]
x[y] # 위와 같은 인덱싱보다 더 빠르다. 굳이 which사용 필요 x
# 만약 logical vector로 인덱싱하는데 NA가 포함돼있으면 
# NA로 엘리멘트가 출력됨
# 그러나 which를 사용하면 true만 뽑아오므로
# NA의 유무 정보가 손실될 수 있음.


y <- c(F,F,F,F)
x[!y] # 하면 x의 모든 거 출력되지만
x[-which(y)] # 하면 아무것도 출력 안됨
# which는 조심히 사용








# ch.5 control flow, choice와 loops.
# 제어문의 두가지 주요 기능
# 1. 선택 2. 반복
# 1에는 if, switch() 호출
# 2에는 for, while


# 5.2 choice
# if (condition) true_actione
# if (condition) true action else false_action


x1 <- if (TRUE) 1 else 2
x2 <- if (FALSE) 1 else 2

# 조건이 FALSE 인데 else 로 액션을 지정하지 않으면 명시적으로 Null 이 된다.

greet <- function(name, birthday= FALSE) {
  paste0(
    "Hi ", name,
    if (birthday) " and HAPPY BIRTHDAY"
  )
}
greet("Maria", FALSE)
greet("Maria", TRUE)


# invalid inputs
# 조건은 true 이거나 false  중 하나를 꼭 가져야만 한다. 스칼라 하나를 가져야만한다. 벡터여도 안된다.

if ("x") 1 # true , false 로 evaluation 되지 않음. logical하지않음

if (logical()) 1 # 한 개 이상의 t,F가 지정돼야함. 인자의 길이가 0이라고 뜸

if (NA) 1 # T, F 가 없음

# exception

if (c(T,F)) 1 # 첫번째 요소만 사용됨. 


# 5.2.2 Vectorised if
x <- 1:10
ifelse(x%%5==0, "XXX",as.character(x))
ifelse(x%%2==0, "even","odd")

# 만약 NA가 포함돼있으면?
x <- c(1:5, NA, 6:10)
ifelse(x%%5==0, "XXX",as.character(x))



# 5.2.3 switch() 구문
x_option <- function(x) {
  switch(x,
         a= "option 1",
         b = "option 2",
         c= "option 3",
         stop("iinvalid x value")
         )
}

x_option("d")



(switch("c",a=1,b=2)) # a 나 b가 아닌 c를 입력하면 stop option이 나와야하지만 stop을 지정 안해주면 NULL

legs <- function(x) {
  switch(x,
         cow=,
         horse=,
         dog=4,
         stop("unknown"))
}
legs("cow") # cow 가 함수 내 지정 안돼있어도 다음거중 찾아서 해줌. c의 로직과 비슷,



# 5.3 loops
# for (item in vector) perform_action
for (i in 1:3) {
  print(i)
}


vars <- letters[1:4]
for (j in vars) {
  print(j)
}


i <- 100
for (i in 1:3) {}
i # i가 3으로 할당돼있음


for (i in 1:10) {
  if (i < 3)
    next
  print(i)
  
  if (i >= 5)
    break
}



# 5.3.1 common pitfalls

means <- c(1,50,20)
out <- vector("list", length(means))

for (i in 1:length(means)) {
  out[[i]] <- rnorm(10, means[[i]])
}
out


xs <- as.Date(c("2020-01-01","2010-01-01"))
for (x in xs) {
  print(x)
} # 메타정보를 잃어버려서 날짜형이 유지 안됨

for (i in seq_along(xs)) {
  print(xs[[i]])
} # i가 1:2 로 갖게됨. xs의 메타정보는 잃지 않음.



# 5.3.2 Related tools
# while, repeat 웬만하면 사용 지양


### for
vals <- 1:3
for ( i in seq_along(vals)) print(i)


### while
i <- 1
while(i < 4) {
  print(i)
  i <- i+1
}

### repeat

i <- 1
repeat{
  print(i)
  i <- i + 1
  if (i>3) break
}

sessionInfo()
