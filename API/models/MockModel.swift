//
//  MockModel.swift
//  NavigationApp
//
//  Created by Alex M on 13.02.2023.
//

import Foundation
import Fakery

class MockModel {
    
    static let shared = MockModel()
    
    public var feedStories: [FeedStoriesItemCellInfo] = []
    public var feedPosts: [FeedPostItemInfo] = []
    public var users: [UserProfileInfo] = []
    
    private init() {
        createUsers()
        createFeedStories()
        createFeedPosts()
    }
    
    
    private func createUsers() {
        (1...12).forEach {
            self.users.append(
                UserProfileInfo(
                    id: UUID().uuidString,
                    publicName: Faker().internet.username(),
                    userImage: "user\($0)",
                    name: Faker().name.firstName(),
                    surname: Faker().name.lastName(),
                    dateOfBirth: nil,
                    isMale: nil,
                    homeСity: nil,
                    profession: Faker().commerce.department(),
                    photos: createPhotos(count: Int.random(in: 1...30)),
                    publications: Int.random(in: 0...50),
                    subscriptions: Int.random(in: 0...2000),
                    subscribers: Int.random(in: 0...2000)
                )
            )
        }
        self.users.append(testUser)
    }
    
    private func createPhotos(count: Int) -> [PhotoItemInfo] {
        var photos: [PhotoItemInfo] = []
        (1...count).forEach {_ in
            while true {
                let newPhoto = createPhoto()
                if !photos.contains(where: { photo in
                    photo.imageUrl == newPhoto.imageUrl
                }) {
                    photos.append(newPhoto)
                    break
                }
            }
        }
        return photos
    }
    
    
    private func createPhoto() -> PhotoItemInfo {
        switch Int.random(in: 1...2) {
        case 1: return PhotoItemInfo(date: randomDate(), imageUrl: "food\(Int.random(in: 1...33))", album: "food")
        default: return PhotoItemInfo(date: randomDate(), imageUrl: "deserts\(Int.random(in: 1...34))", album: "deserts")
        }
    }
    
    
    private func randomDate() -> Date {
        Date(timeIntervalSince1970: TimeInterval(Date().timeIntervalSince1970 - Double.random(in: 0...2_500_000)))
    }
    
    private func createFeedStories() {
        (1...13).forEach {
            let isAddButtonVisible = ($0 == 1) ? true : false
            let isNewStory = ($0 == 1) ? false : true
            self.feedStories.append(FeedStoriesItemCellInfo(image: "user\($0)", username: "user\($0)", isAddButtonVisible: isAddButtonVisible, isNewStory: isNewStory))
        }
    }
    
    
    private func createTextPost() -> String {
        textPosts[Int.random(in: 1...textPosts.count - 1)]
    }
    
    
    private func createFeedPosts() {
        (1...users.count).forEach { user in
            
            (0...Int.random(in: 0...20)).forEach { _ in
                let user = users.randomElement()!
                self.feedPosts.append(
                    FeedPostItemInfo(
                        id: UUID().uuidString,
                        date: randomDate(),
                        userImage: user.userImage!,
                        username: [user.name, user.surname].compactMap { $0 }.joined(separator: " "),
                        userID: user.id,
                        profession: user.profession!,
                        postText: createTextPost(),
                        postImage: createPhoto(),
                        numberOfLikes: Int.random(in: 0...2000),
                        isLiked: Bool.random(),
                        numberOfComments: Int.random(in: 0...2000),
                        isAddToBookmarks: false,
                        comments: nil
                    )
                )
            }
        }
    }
    
    
    public lazy var testUser = UserProfileInfo(
        id: "0448619F-3BE2-47A9-9D8A-30B2E91E5734",
        publicName: "annaux_designer",
        userImage: "user13",
        name: "Анна",
        surname: "Мищенко",
        dateOfBirth: nil,
        isMale: nil,
        homeСity: nil,
        profession: "дизайнер",
        photos: createPhotos(count: Int.random(in: 10...30)),
        publications: 1400,
        subscriptions: 477,
        subscribers: 161485)
    
    
    public var newUser = UserProfileInfo(
        id: "EF064940-AFD8-4D7C-A066-DE45FC7B18CC",
        publicName: "",
        userImage: "",
        name: "",
        surname: "",
        dateOfBirth: nil,
        isMale: nil,
        homeСity: nil,
        profession: "",
        photos: [],
        publications: 0,
        subscriptions: 0,
        subscribers: 0)
    
    
    let textPosts: [String] =
    [
"""
Всем доброе утро!
На одну сбывшуюся мечту создавайте две новые!
Ставьте себе высоченные цели и бегите к ним! Жизнь одна и она дана для того, чтобы мы стали счастливыми. Миллионы людей просиживают свое счастье возле экранов телевизоров, за компьютерными играми, даже не предполагая насколько яркий и достойный мир вокруг нас!
""",

    """
    Жил когда-то непобедимый воин, любивший, при случае, показать свою силу. Он вызывал на бой всех прославленных богатырей и мастеров воинских искусств и всегда одерживал победу.
    
    Однажды услышал он, что неподалёку от его селения высоко в горах поселился отшельник — большой мастер рукопашного боя. Отправился богатырь искать отшельника, чтобы ещё раз доказать, что сильнее его нет на свете человека. Добрался воин до жилища отшельника и замер в удивлении. Думал он встретить могучего бойца, а увидел тщедушного старикашку, упражнявшегося перед хижиной в старинном искусстве вдохов и выдохов.
    
    — Неужто ты и есть тот человек, которого народ прославляет как великого воина? Воистину людская молва сильно преувеличила твою силу. Да ты не сможешь даже сдвинуть с места каменную глыбу, у которой стоишь, а я, если захочу, могу поднять её и даже отнести в сторону, — презрительно сказал богатырь.
    
    — Внешность бывает обманчива, — спокойно ответил старик. — Ты знаешь, кто я, а я знаю, кто ты, и зачем ты сюда пришёл. Каждое утро я спускаюсь в ущелье и приношу оттуда каменную глыбу, которую и разбиваю головой в конце моих утренних упражнений. На твоё счастье, сегодня я не успел ещё этого сделать, и ты можешь показать своё умение. Ты же хочешь вызвать меня на поединок, а я просто не стану драться с человеком, который не сможет сделать такой пустяк.
    
    Раззадоренный богатырь подошёл к камню, что было сил ударил его головой и свалился замертво.
    
    Вылечил добрый отшельник незадачливого воина, а потом долгие годы учил его редкому искусству — побеждать разумом, а не силой.
    """,

    """
    Пожилой профессор читал последнюю лекцию. Он написал несколько примеров и в первом из них было несколько очень грубых ошибок. Студенты сначала были в недоумении, а потом открыто начали посмеиваться над пожилым преподавателем.
    
    Дочитав лекцию, преподаватель сказал:
    
    — Я намеренно написал первое уравнение неправильно, потому что хотел, чтобы вы научились самому важному уроку в жизни. Сегодняшняя лекция показала, как мир будет относиться к вам. Вы не заметили, что я написал правильно несколько примеров и многое вам объяснил. Никто из вас не похвалил меня и не поддержал. Но вы все как один высмеивали и критиковали меня из-за одной ошибки. И это мой главный урок. Люди, которым до вас нет дела, всегда будут поступать также. Они забудут обо всём хорошем и правильном, что вы сделали. Но будут критиковать за малейшую ошибку. Не разочаровывайтесь, всегда поднимайтесь выше всех насмешек и критики. Оставайтесь сильными!
    """,

    """
    Молодого, недавно назначенного менеджера компании IBM руководство вызвало на ковёр. Ещё бы! Он совершил сделку, на которой фирма потеряла 10 миллионов долларов. Когда сотрудник понял свою ошибку, было уже поздно, деньги уплыли.
    
    Зайдя в кабинет и чувствуя свою вину, он, не ожидая того, что ему скажут, произнёс:
    
    — Я понимаю, что вы вправе меня уволить, и, признавая свою вину, принимаю ваше решение.
    
    — Уволить? — произнёс руководитель. — Мы только что потратили 10 миллионов на ваше обучение и не вправе разбрасываться такими ценными кадрами. Идите работать!
    """,
    """
    В одном городе жил старец, знаменитый своей мудростью, почтенного возраста, но очень бедный. Однажды царь услышал о мудрости этого старца и сообщил ему, что желает посетить его в его доме и послушать его слова.
    
    — Чем же мы будем угощать царя? — спросила его жена. — У нас дома почти ничего нет!
    
    — Принесёшь то, что у тебя есть, и сделаешь так, как я тебе скажу, — ответил старец.
    
    Когда царь пришёл, жена старца принесла арбуз. Хозяин взял арбуз в руку, ощупал его пальцами и сказал жене:
    
    — Есть арбуз лучше этого. Пойди и принеси его.
    
    Жена унесла арбуз, потом вернулась, и в руках у неё был снова арбуз. Старец и его ощупал и сказал ей унести этот и принести другой. Жена ничего не ответила и сразу сделала, как он сказал. На этот раз муж остался доволен. Он разрезал арбуз и подал царю угощение. После беседы со старцем царь вернулся к себе во дворец весёлый и довольный гостеприимством, которое проявил старец. Он и не знал, что в доме у старца был всего один арбуз…
    """
    ]


    func addUser(user: UserProfileInfo) {
        self.users.append(user)
    }
}
