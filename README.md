# Set(game)
#### The rules to the game of [Set](https://en.wikipedia.org/wiki/Set_(game)).

## 项目构建过程
### Layout
### Data structure
1. Struct Card 用枚举为属性赋值，属性名字没有写死，为以后改变view的现实准备
2. Struct SetGame 初始化时通过遍历枚举常量创建81张不同属性的SetCard