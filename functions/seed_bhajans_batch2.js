const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: 'bhajan-sangraha-pahadilabs',
});

const db = admin.firestore();

const bhajans = [
  {
    number: 67,
    title_devanagari: 'कृष्ण भजनमा लाग्यो',
    title_roman: 'Krishna Bhajanma Laagyo',
    category: 'krishna',
    first_line_devanagari: 'कृष्ण भजनमा लाग्यो मेरो मन,',
    first_line_roman: 'Krishna bhajanma laagyo mero man,',
    keywords: ['krishna', 'कृष्ण', 'bansuri', 'बाँसुरी', 'dudh', 'दूध', 'phool', 'फूल', 'jal', 'जल', 'phal', 'फल', 'bhajan'],
    source_book: 'वृहद् भजन माला (Vrihad Bhajan Mala)',
    lyrics_devanagari: `कृष्ण भजनमा लाग्यो मेरो मन,
आज बाँसुरीको धुन सुनेर ।
दूध चढाऊँ भने बाच्छाको जुठो ।
बाच्छाले छोडी दियो दूध ।।
बाँसुरीको धुन सुनेर ।।
कृष्ण भजनमा.........।

फूल चढाऊँ भने भमराको जुठो ।
भमराले छाडिदियो फूल ।।
बाँसुरीको धुन सुनेर ।।
कृष्ण भजनमा.........।

जल चढाऊँ भने माछाको जुठो ।
माछाले छोडिदियो जल ।।
बाँसुरीको धुन सुनेर ।।
कृष्ण भजनमा.........।

फल चढाऊँ भने चराको जुठो ।
चराले छाडिदियो फल ।।
बाँसुरीको धुन सुनेर ।।
कृष्ण भजनमा.........।`,
    lyrics_roman: `Krishna bhajanma laagyo mero man,
Aaja bansuriko dhun sunera.
Dudh chadhaau bhane baachhako jutho.
Baachhale chhodi diyo dudh,
Bansuriko dhun sunera.
Krishna bhajanma.........

Phool chadhaau bhane bhamarako jutho.
Bhamarale chhadidiyo phool,
Bansuriko dhun sunera.
Krishna bhajanma.........

Jal chadhaau bhane maachhako jutho.
Maachhale chhodidiyo jal,
Bansuriko dhun sunera.
Krishna bhajanma.........

Phal chadhaau bhane charako jutho.
Charale chhadidiyo phal,
Bansuriko dhun sunera.
Krishna bhajanma.........`,
  },
  {
    number: 68,
    title_devanagari: 'श्री कृष्ण',
    title_roman: 'Shree Krishna',
    category: 'krishna',
    first_line_devanagari: 'तिरिमा तिरि कृष्ण बाँसुरी बज्यो।',
    first_line_roman: 'Tirima tiri Krishna bansuri bajyo.',
    keywords: ['krishna', 'कृष्ण', 'bansuri', 'बाँसुरी', 'darshan', 'दर्शन', 'gokul', 'गोकुल', 'brindavan', 'वृन्दावन', 'bhagwan', 'भगवान'],
    lyrics_devanagari: `तिरिमा तिरि कृष्ण बाँसुरी बज्यो।
हरायो मनको वेदना हे मेरा भगवान।।
हामीले दिन्छौं नि कृष्ण भक्ति फूल ।
खुशीले ग्रहण गर्नु होस हे मेरा भगवान ।।
तिरिमा तिरि --- --- ---
तिर्थले पाउ कृष्ण, ब्रतले पाउँ ।
दर्शन तिम्रो पाउ हे मेरा भगवान ।।
तिरिमा तिरि --- --- ---
गोकुल गए नी कृष्ण वृन्दावन गएँ ।
भेटिनँ तिमीलाई कहि कहि पनि हे मेरा भगवान
तिरिमा तिरि - - -
पुराण सुने बुझे कृष्ण शास्त्र नि गुने
किन हो दर्शन दिएनौ हे मेरा भगवान
तिरिमा ---
बाहिर खोजे कृष्ण संसारमा खोजे
अब चैं भित्र खोज्दा म हे मेरा भगवान
तिरिमा तिरि - - -`,
    lyrics_roman: `Tirima tiri Krishna bansuri bajyo.
Harayo manko bedana he mera bhagwan..
Hamile dinchhau ni Krishna bhakti phool.
Khushile grahan garnu hos he mera bhagwan..
Tirima tiri --- --- ---
Tirthale paau Krishna, bratale paau.
Darshan timro paau he mera bhagwan..
Tirima tiri --- --- ---
Gokul gaye ni Krishna Brindavan gaye.
Bhetina timilai kahi kahi pani he mera bhagwan.
Tirima tiri --- --- ---
Puran sune bujhe Krishna shastra ni gune
Kina ho darshan diyenau he mera bhagwan
Tirima ---
Bahir khoje Krishna sansarma khoje
Aba chai bhitra khojda ma he mera bhagwan
Tirima tiri - - -`,
  },
  {
    number: 69,
    title_devanagari: 'सके त भगवान',
    title_roman: 'Sake Ta Bhagwan',
    category: 'krishna',
    first_line_devanagari: 'सके त भगवान फूल चढाउँला ।',
    first_line_roman: 'Sake ta bhagwan phool chadhaula.',
    keywords: ['krishna', 'कृष्ण', 'radha', 'राधा', 'bhagwan', 'भगवान', 'vrindavan', 'वृन्दावन', 'shaligram', 'शालिग्राम', 'damodar', 'दामोदर', 'vaikuntha', 'बैकुण्ठ'],
    lyrics_devanagari: `सके त भगवान फूल चढाउँला ।
नसके भगवान शरण परौंला ।।
सके त ........
ढकमक फूलैफुल्यो वृन्दावनैमा ।
टिपी देउन राधिका सुनको थालिमा ।।
सके त ........
सुनको हात्ती सुनको घोडा सुनै रथैमा ।
कृष्णजीको सवार भयो राधा साथैमा ।।
सकेत त .......
राम्रो लीला बाँसुरीको स्वर सुनाउँदै ।
कृष्णजी चैं नाच्दै गाउँदै वंशी बजाउँदै ।।
सके त ............
कृष्ण गण्डकीको शिरमा दामोदर कुण्ड ।
शालिग्राम भगवान लैजाऊ वैकुण्ठ ।।
सके त ...........
सप्त कोशी कोकाहा विष्णु पादुका ।
यज्ञ वराह भगवान लैजाऊ वैकुण्ठ ।।
सके त .........
वृन्दावनमा फूलै फुल्यो कमलको सरी ।
शालिग्राम भगवान् लान्छौ कसरी ।।
सके त.............`,
    lyrics_roman: `Sake ta bhagwan phool chadhaula.
Nasake bhagwan sharan paraula..
Sake ta ........
Dhakamaka phulaiphulyo brindabanaima.
Tipi deun radhika sunko thalima..
Sake ta ........
Sunko hatti sunko ghoda sunai rathaima.
Krishnajiko sawar bhayo radha sathaima..
Sake ta .......
Ramro lila bansuriko swor sunaudai.
Krishnaji chai nachdai gaudai banshi bajaudai..
Sake ta ............
Krishna gandakiko shirama damodar kunda.
Shaligram bhagwan laijau baikuntha..
Sake ta ...........
Sapta koshi kokaha bishnu paduka.
Yagya barah bhagwan laijau baikuntha..
Sake ta .........
Brindabanma phulai phulyo kamalko sari.
Shaligram bhagwan lanchhau kasari..
Sake ta.............`,
  },
  {
    number: 70,
    title_devanagari: 'कति पर्खिउँ आउँदैनौ',
    title_roman: 'Kati Parkhiu Aaudainau',
    category: 'krishna',
    first_line_devanagari: 'कति पर्खिउँ आउँदैनौ जहिले नि ।',
    first_line_roman: 'Kati parkhiu aaudainau jahile ni.',
    keywords: ['krishna', 'कृष्ण', 'darshan', 'दर्शन', 'mathura', 'मथुरा', 'vrindavan', 'वृन्दावन', 'prabhu', 'प्रभु'],
    lyrics_devanagari: `कति पर्खिउँ आउँदैनौ जहिले नि ।
दर्शन तिम्रो पाउँदैनौ कहिले नि ।
भन्नु नभाको...........
कृष्ण प्रभु किन दर्शन दिन आउनु नभाको ।।
कति.........
दिन बित्यो तिमीलाई नै सम्झेर ।
कुरि बस्यौ आउँछौं कि भनेर ।।
भन्नु नभाको......... कृष्ण प्रभु........
कति.........
खोजी हिड्यौ मथुरा वन्दावन ।
जल्नै लाग्यो यो हाम्रो भित्रि मन
भन्नु नभाको......... कृष्ण प्रभु........
कति.........
बिन्ति सुन्ने तिमी बाहेक को छ र ।
दर्शन देउ है किंकरै सम्झेर ।
भन्नु नभाको......... कृष्ण प्रभु........
कति.........
सुनि देउहै यो हाम्रो बेदना ।
चरण पर्यौ शरणमा लेउन ।।
भन्नु नभाको......... कृष्ण प्रभु........
कृष्ण जहाँ भएपनि आउँहै जसौरी ।।
कति..............`,
    lyrics_roman: `Kati parkhiu aaudainau jahile ni.
Darshan timro paudainau kahile ni.
Bhannu nabhako...........
Krishna prabhu kina darshan dina aaunu nabhako ||
Kati.........
Din bityo timilai nai samjhera.
Kuri basyau aauchhau ki bhanera..
Bhannu nabhako......... Krishna prabhu........
Kati.........
Khoji hidyau mathura vrindavan.
Jalnai laagyo yo hamro bhitri man
Bhannu nabhako......... Krishna prabhu........
Kati.........
Binti sunne timi bahek ko chha ra.
Darshan deu hai kinkarai samjhera.
Bhannu nabhako......... Krishna prabhu........
Kati.........
Suni deuhai yo hamro bedana.
Charan paryau sharanma leuna..
Bhannu nabhako......... Krishna prabhu........
Krishna jaha bhaepani aauhai jasauri..
Kati..............`,
  },
  {
    number: 71,
    title_devanagari: 'नौनी माखन चोरेको',
    title_roman: 'Nauni Makhan Choreko',
    category: 'krishna',
    first_line_devanagari: 'नौनी माखन चोरेको किन किन',
    first_line_roman: 'Nauni makhan choreko kina kina',
    keywords: ['krishna', 'कृष्ण', 'makhan', 'माखन', 'nauni', 'नौनी', 'gopini', 'गोपिनी', 'mata', 'माता'],
    lyrics_devanagari: `नौनी माखन चोरेको किन किन
जोरी पारी दुनियाँ हसाउँन
नौनी माखन........
नौनी मखन हराएको सधैं खबर आउँछ ।
गोपीनीको उजुर मैले सधैं सुन्नु पर्छ ।।
तिम्रा सामु........ खादिन्छु (कसम-२)
छैन मैले चोरेको माखन
नौनी माखन........
कृष्ण तेरो इच्छा मैले पूरा गरिन कि ।
खानलाउन दिइन की मायाँ गरिन कि ।।
तिम्रा सामु........ नौनी माखन ...
ओखलमा बाँधी राख्छु कहिल्यै पुकाउँदिन ।
काले तँलाई आजदेखि कतै जान दिन्न ।।
तिम्रा सामु........ नौनी माखन...
कृष्ण भन्छन् माताजीको पाउ समातेर ।
आँखाबाट मोती ढिका आँसु खसालेर ।।
तिम्रा सामु खाई दिन्छु कसम,
छैन मैले चोरेको माखन ।
तिम्रा सामु........ नौनी माखन.....
हाम्रा घर आउन मन लाग्छ सबैलाई ।
चोरी गरें भन्दै उजुर गर्छन हजुरलाई
तिम्रा सामु ....... नौनी माखन .........`,
    lyrics_roman: `Nauni makhan choreko kina kina
Jori pari duniya hasaauna
Nauni makhan........
Nauni makhan haraeko sadhai khabar aauchha.
Gopiniko ujur maile sadhai sunnu parchha..
Timra samu........ khadinchhu (kasam-2)
Chhaina maile choreko makhan
Nauni makhan........
Krishna tero ichchha maile pura garina ki.
Khana launa diina ki maya garina ki..
Timra samu........ Nauni makhan ...
Okhalma bandhi rakhchhu kahilyai pukaundina.
Kale tailai aajadekhi katai jana dinna..
Timra samu........ Nauni makhan...
Krishna bhanchhan matajiko pau samatera.
Aankhabat moti dhika aasu khasalera..
Timra samu khai dinchhu kasam,
Chhaina maile choreko makhan.
Timra samu........ Nauni makhan.....
Hamra ghar aauna man laagchha sabailai.
Chori garau bhandai ujur garchhan hajurilai
Timra samu ....... Nauni makhan .........`,
  },
  {
    number: 72,
    title_devanagari: 'जय जय तुलसा',
    title_roman: 'Jaya Jaya Tulasa',
    category: 'other',
    first_line_devanagari: 'जय जय तुलसा जय जय राम',
    first_line_roman: 'Jaya jaya tulasa jaya jaya ram',
    keywords: ['tulasa', 'तुलसा', 'ram', 'राम', 'lakshman', 'लक्ष्मण', 'hanuman', 'हनुमान'],
    lyrics_devanagari: `जय जय तुलसा जय जय राम
जय जय लक्ष्मण जय हनुमान
जय जय.....
कस्की छोरी तुलसा कस्का छोरा राम
कस्का छोरा लक्ष्मण कस्का हनुमान
आफै आफ तुलसा दशरथका राम
दशरथकै लक्ष्मण वायु हनुमान
जय जय.....
कहाँ बस्छिन् तुलसा कहाँ बस्छन् राम
कहाँ बस्छन् लक्ष्मण कहाँ हनुमान
मठमा बस्छिन् तुलसा, मुखमा बस्छन् राम
हृदयमा लक्ष्मण पाउँमा हनुमान
जय जय.....
के खान्छिन् तुलसा के खान्छन् राम
के खान्छन् लक्ष्मण के हनुमान
जलहारी तुलसा फलहारी राम
धूपदिप लक्ष्मण लड्डु हनुमान
जय जय.....`,
    lyrics_roman: `Jaya jaya tulasa jaya jaya ram
Jaya jaya lakshman jaya hanuman
Jaya jaya.....
Kaski chhori tulasa kaska chhora ram
Kaska chhora lakshman kaska hanuman
Aafai aafa tulasa dasharathka ram
Dasharathkai lakshman bayu hanuman
Jaya jaya.....
Kaha baschhin tulasa kaha baschhan ram
Kaha baschhan lakshman kaha hanuman
Mothma baschhin tulasa, mukhma baschhan ram
Hridayama lakshman pauma hanuman
Jaya jaya.....
Ke khanchhin tulasa ke khanchhan ram
Ke khanchhan lakshman ke hanuman
Jalahari tulasa phalahari ram
Dhupdip lakshman laddu hanuman
Jaya jaya.....`,
  },
  {
    number: 73,
    title_devanagari: 'एकादशी तुलसी',
    title_roman: 'Ekadashi Tulasi',
    category: 'other',
    first_line_devanagari: 'एकादशी तुलसी तिलको दान',
    first_line_roman: 'Ekadashi tulasi tilko daan',
    keywords: ['ekadashi', 'एकादशी', 'tulasi', 'तुलसी', 'vrat', 'व्रत', 'baikuntha', 'बैकुण्ठ', 'damodar kunda', 'दामोदर कुण्ड'],
    lyrics_devanagari: `एकादशी तुलसी तिलको दान
हामीलाई बैकुण्ठ लैजाऊ भगवान्
एकादशी तुलसी.....
सबै व्रत बस्नुभन्दा एकादशी ठूलो
एकादशी व्रत बसे पाप हुन्छ धुलो
एकादशी एकादशी व्रत बसौँन
सबै भक्त मिलीजुली कीर्तन गरौँन
एकादशी तुलसी.....
एकादशी धेरै नाम छन् कोही छन् पुत्रदा
वर्ष दिनमा एक दिन चाँही पर्छिन निर्जला
एकादशी तुलसी.....
हरिसयनी र रमा हरि बोधनी
पावन नाम धेरै छन् पाप मोक्षनी
एकादशी तुलसी.....
फलदायक छन् सबै कोही छन् कामिका
मोक्षदा उत्तिकै छन् वर्षे दिनका
एकादशी तुलसी.....
देवघाट मुक्ती क्षेत्र दामोदर कुण्ड
श्री मुक्तिनारायण प्रभु लैजाऊ बैकुण्ठ
एकादशी तुलसी.....`,
    lyrics_roman: `Ekadashi tulasi tilko daan
Hamilai baikuntha laijau bhagwan
Ekadashi tulasi.....
Sabai brata basnubhanda ekadashi thulo
Ekadashi brata base paap hunchha dhulo
Ekadashi ekadashi brata basauna
Sabai bhakta milijuli kirtan garauna
Ekadashi tulasi.....
Ekadashi dherai naam chhan kohi chhan putrada
Barsha dinma ek din chahi parchhin nirjala
Ekadashi tulasi.....
Harisayani ra rama hari bodhani
Pawan naam dherai chhan paap mokshani
Ekadashi tulasi.....
Phaldayak chhan sabai kohi chhan kamika
Mokshada uttikai chhan barshai dinka
Ekadashi tulasi.....
Devghat mukti kshetra damodar kunda
Shree muktinarayan prabhu laijau baikuntha
Ekadashi tulasi.....`,
  },
  {
    number: 74,
    title_devanagari: 'रामको पनि मायाँ',
    title_roman: 'Ramko Pani Maya',
    category: 'ram',
    first_line_devanagari: 'रामको पनि माया श्यामको पनि माया ।',
    first_line_roman: 'Ramko pani maya shyamko pani maya.',
    keywords: ['ram', 'राम', 'shyam', 'श्याम', 'hari', 'हरि', 'shabari', 'शवरी', 'mirabai', 'मीराबाई'],
    lyrics_devanagari: `रामको पनि माया श्यामको पनि माया ।
यो अधुरो जीवन दुई दिनको घाम छायाँ ।।
रामको.........
पवित्र मनले जपेर हेर देखिन्छ ईश्वर
यो आत्मा हाम्रो समर्पण गरौ हरिलाई सम्झेर ।
रामको........
सत्यको बाटो लागेर हामी प्रभुलाई भजौंन ।
काम र क्रोध लोभ र मोह तुरुन्तै त्यागौंन ।।
रामको........
जपेर नाम संसार तरे शवरी मीरावार्इ ।
तर्ने छौं हामी जपेमा नाम सम्झेमा हरिलाई ।।
रामको........`,
    lyrics_roman: `Ramko pani maya shyamko pani maya.
Yo adhuro jeewan dui dinko gham chhaya..
Ramko.........
Pabitra manle japera hera dekhinchha ishwor
Yo aatma hamro samarpan garau harilai samjhera.
Ramko........
Satyako bato lagera hami prabhulai bhajauna.
Kaam ra krodh lobh ra moha turuntai tyagauna..
Ramko........
Japera naam sansar tare shabari mirabai.
Tarne chhau hami japema naam samjhema harilai..
Ramko........`,
  },
  {
    number: 75,
    title_devanagari: 'हे मेरी आमा',
    title_roman: 'He Meri Aama',
    category: 'ram',
    first_line_devanagari: 'हे मेरी आमा दिनुहोस् विदा, म जान्छु वनमा ।',
    first_line_roman: 'He meri aama dinuhos bida, ma jaanchhu banama.',
    keywords: ['sita', 'सीता', 'ram', 'राम', 'lakshman', 'लक्ष्मण', 'vanvas', 'वनमा', 'aama', 'आमा'],
    lyrics_devanagari: `हे मेरी आमा दिनुहोस् विदा, म जान्छु वनमा ।
सीता र लक्ष्मण साथमा लिई म जान्छु वनमा ।।
पिताको आज्ञा शिरोपर गर्छु, फर्केर आउनेछु ।
हजुरहरुको चरणको ध्यान, गरेर बस्दछु ।
कसैलाई पनि छैन है दोष, यो मेरो तक्दिर ।
मन होस् गाढा हुदैन टाढा भक्ति र भावर ।।
हे मेरी.............
छैठीको दिनमा भावीले लेख्याको मेट्न सक्दछ ।
नमानी शर्म आ-आफ्नो कर्म, भोग गर्नु पर्दछ ।
मनको भाव मेटिन्न कही त्यो घुम्छु वनमा ।
कहाँको आस कहाँको वास संसारै सपना ।।
हे मेरी.............
कहिलेको महल कहिलेको जंगल भावीले लेखेको ।
भोग गर्नु पर्छ हुदैन आज, आँखाले देखेको ।।
भोक लाग्यो भने कन्दमूल खान्छु, विभिन्नजातको ।
निन्द्रामा लागे पत्करमा सुत्छु सिरानी हातको ।।
हे मेरी.............
रुखको बोक्रा लगाउछुँ लुगा, पालुवा पातको ।
खिलेर स्याउला ओढ्दछु आमा चार प्रहर रातको ।
हे मेरी आमा...... सीता र लक्ष्मण......`,
    lyrics_roman: `He meri aama dinuhos bida, ma jaanchhu banama.
Sita ra lakshman sathama lii ma jaanchhu banama..
Pitako aagya shiropar garchhu, pharkera aaunechhu.
Hajurharuko charanko dhyan, garera basdachhu.
Kasailai pani chhaina hai dosh, yo mero takdir.
Man hos gadha hudaina tadha bhakti ra bhawar..
He meri.............
Chhaithiko dinma bhavile lekhyako metna sakdachha.
Namani sharma aa-aafno karma, bhoga garnu pardachha.
Manko bhaav metinna kahi tyo ghumchhu banama.
Kahako aash kahako baas sansarai sapana..
He meri.............
Kahileko mahal kahileko jungal bhavile lekheko.
Bhoga garnu parchha hudaina aaja, aakhale dekheko..
Bhok laagyo bhane kandamul khanchhu, bibhinnajaatko.
Nindrama laage patkarma sutchhu sirani haatko..
He meri.............
Rukhko bokra lagauchhu luga, paluwa paatko.
Khilera syaula odhdachhu aama char prahar raatko.
He meri aama...... sita ra lakshman......`,
  },
  {
    number: 76,
    title_devanagari: 'धोका होला धोका होला',
    title_roman: 'Dhoka Hola Dhoka Hola',
    category: 'other',
    first_line_devanagari: 'धोका होला धोका होला धोका होला है ।',
    first_line_roman: 'Dhoka hola dhoka hola dhoka hola hai.',
    keywords: ['dhoka', 'धोका', 'jindagi', 'जिन्दगी', 'yamaraj', 'यमराज', 'hari naam', 'हरि नाम'],
    lyrics_devanagari: `धोका होला धोका होला धोका होला है ।
जिन्दगीको अन्तिम क्षणमा धोका होला है ।।
धोका..............
सुन्ने कान बैरा हुन्छन् देख्ने आँखा अन्धा हुन्छन् ।
मलेका ती दाँका पङ्क्ति सबैले नै बिदा लिन्छन् ।।
त्यतिखेर जीवनमा धोका होला है ।।
धोका..................
नत साखा सन्तान साथमा नत धन दौलत हातमा ।
आउँदा केवल काखमा थियौँ, जाँदा एक्लै मसान घाटमा ।।
त्यतिखेर जीवनमा धोका होला है ।।
धोका..................
अब आयो जाने दिन यमराज आँऊदैछन् लिन ।
प्यारा मेरा शाखा सन्तान् भेला हुन्छन् बिदादिन ।।
त्यतिखेर जीवनमा धोका होला है ।।
धोका..................
पत्नी घरका दैलासम्म, साथी सङ्गी खोला सम्म ।
यमलोकको बाटो लिंदा, आफ्ना साथमा कोही हुन्न ।।
सबैले हरि नाम जपी हालौं है ।।
हैन भने जीवनमा धोका होला है ।।
धोका..................`,
    lyrics_roman: `Dhoka hola dhoka hola dhoka hola hai.
Jindagiko antim kshanma dhoka hola hai..
Dhoka..............
Sunne kaan baira hunchhan dekhne aankha andha hunchhan.
Maleka ti danka pangti sabaile nai bida linchhan..
Tyetikher jeewanma dhoka hola hai..
Dhoka..................
Nata sakha santan sathma nata dhan daulat haatma.
Aaunda kewal kaakhma thiyau, janda eklai masan ghatma..
Tyetikher jeewanma dhoka hola hai..
Dhoka..................
Aba aayo jane din yamaraj aaundai chhan lina.
Pyara mera sakha santan bhela hunchhan bidadina..
Tyetikher jeewanma dhoka hola hai..
Dhoka..................
Patni gharka dailasamma, sathi sangi khola samma.
Yamalokko bato linda, aafna sathma kohi hunna..
Sabaile hari naam japi halau hai..
Haina bhane jeewanma dhoka hola hai..
Dhoka..................`,
  },
  {
    number: 77,
    title_devanagari: 'छेक्यो मलाई',
    title_roman: 'Chhekyo Malai',
    category: 'other',
    first_line_devanagari: 'छेक्यो मलाई माया जालै ले ।',
    first_line_roman: 'Chhekyo malai maya jalai le.',
    keywords: ['maya', 'माया', 'bhajan', 'भजन', 'mukti', 'मुक्ति', 'bhaba sagar', 'भव सागर'],
    lyrics_devanagari: `छेक्यो मलाई माया जालै ले ।
पुण्य नभई लान्छ कि त पापी कालै ले ।
डुब्नलाग्यो भव सागर ...
आउन प्रभु दया गरी लाउन किनार
छेक्यो मलाई .....
आँसु झर्छ बरर कस्ले पुछी देला ।
यो दुःखको सागरबाट कहिले मुक्ति होला ।
छेक्यो मलाई ...
भजन गर्न बस्छौ यहाँ मन छ कहाँ कहाँ ।
विषयको बासनाले लान्छ जहाँ जहाँ ।।
छेक्यो मलाई ...
साँझ बिहान जैले तैले घुम्छौ खेतबारी ।
मेरो मेरो भन्दा भन्दै फुल्यो केश दारी
छेक्यो मलाई ...
आँखा पनि देखिंदैन कान बहिरो भयो ।
फूल जस्तो जीवन हाम्रो, आज कता गयो ।।
छेक्यो मलाई ...`,
    lyrics_roman: `Chhekyo malai maya jalai le.
Punya nabhai lanchha ki ta paapi kalai le.
Dubnalagyo bhaba sagar ...
Aauna prabhu daya gari launa kinar
Chhekyo malai .....
Aansu jharchha barara kasle puchhi dela.
Yo dukhako sagarbaat kahile mukti hola.
Chhekyo malai ...
Bhajan garna baschhau yaha man chha kaha kaha.
Bishayako basanale lanchha jaha jaha..
Chhekyo malai ...
Sanjh bihan jailai tailai ghumchhau khetbari.
Mero mero bhanda bhandai phulyo kesh dari
Chhekyo malai ...
Aankha pani dekhidaina kaan bahiro bhayo.
Phool jasto jeewan hamro, aaja kata gayo..
Chhekyo malai ...`,
  },
  {
    number: 78,
    title_devanagari: 'सूर्य',
    title_roman: 'Surya',
    category: 'surya',
    first_line_devanagari: 'हे सूर्य हे ज्योति भास्कर',
    first_line_roman: 'He surya he jyoti bhaskar',
    keywords: ['surya', 'सूर्य', 'jyoti', 'ज्योति', 'bhaskar', 'भास्कर', 'brahma', 'ब्रह्मा', 'shiv', 'शिव', 'vishnu', 'विष्णु', 'narayan', 'नारायण', 'gyan', 'ज्ञान'],
    lyrics_devanagari: `हे सूर्य हे ज्योति भास्कर
मलाई प्रभु, ज्ञान को दान गर
विहान हुने ब्रह्मारुप, दिउसो हुने शिव
साँझपख विष्णु बन्छन, उनै सूर्य देव
हे सूर्य - - - - - - -
विहान तिमी उदाउदा, भाग्छ अन्धकार
हाम्रो पनि ज्ञान को सब अज्ञानलाइ मार
हे सूर्य - - - - - - -
सूर्य रुप नारायण गरी, अब ध्यान
अज्ञानलाइ नाश गरिदेउ अब ज्ञान
हे सूर्य - - - - - - -
भ्याउदिन म पुजा गर्न त गर्छु जप
श्रद्धा रुपि मन बनाई अर्घ दिएँ अब
हे सूर्य हे ज्योति भास्कर
मलाई प्रभु, ज्ञान को दान गर`,
    lyrics_roman: `He surya he jyoti bhaskar
Malai prabhu, gyan ko daan gar
Bihan hune brahmarup, diuso hune shiv
Sanjhapakh bishnu banchhan, unai surya dev
He surya - - - - - - -
Bihan timi udauda, bhagchha andhakar
Hamro pani gyan ko saba agyanlai mar
He surya - - - - - - -
Surya rup narayan gari, aba dhyan
Agyanlai nash garideu aba gyan
He surya - - - - - - -
Bhyaudina ma puja garna ta garchhu jap
Shraddha rupi man banai argha diye aba
He surya he jyoti bhaskar
Malai prabhu, gyan ko daan gar`,
  },
];

(async () => {
  const batch = db.batch();
  for (const b of bhajans) {
    const id = `bhajan-${String(b.number).padStart(3, '0')}`;
    const ref = db.collection('bhajans').doc(id);
    const data = {
      number: b.number,
      title_devanagari: b.title_devanagari,
      title_roman: b.title_roman,
      category: b.category,
      first_line_devanagari: b.first_line_devanagari,
      first_line_roman: b.first_line_roman,
      keywords: b.keywords,
      lyrics_devanagari: b.lyrics_devanagari,
      lyrics_roman: b.lyrics_roman,
      is_published: true,
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    };
    if (b.source_book) data.source_book = b.source_book;
    batch.set(ref, data);
  }
  await batch.commit();
  console.log(`Seeded ${bhajans.length} bhajans (bhajan-067 .. bhajan-078).`);
})().catch((e) => {
  console.error('SEED FAILED', e);
  process.exit(1);
});
