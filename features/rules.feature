Feature: Rules
  Scenario: Litotes (rule)
    When I test rule "Litotes"
    Then the output should contain exactly:
    """
    test.txt:1:1:vale.Litotes:Consider using 'major' instead of 'no minor'
    test.txt:2:1:vale.Litotes:Consider using 'extraordinary' instead of 'no ordinary'
    test.txt:3:1:vale.Litotes:Consider using 'large' instead of 'no small'
    test.txt:4:1:vale.Litotes:Consider using 'large' instead of 'not small'
    test.txt:5:1:vale.Litotes:Consider using 'good' instead of 'not a bad'
    test.txt:7:1:vale.Litotes:Consider using 'rejected' instead of 'not accept'
    test.txt:8:1:vale.Litotes:Consider using 'rejected' instead of 'not accepted'
    test.txt:9:1:vale.Litotes:Consider using 'prevented' instead of 'not allow'
    test.txt:10:1:vale.Litotes:Consider using 'prevented' instead of 'not allowed'
    test.txt:11:1:vale.Litotes:Consider using 'uncertain' instead of 'not certain'
    test.txt:12:1:vale.Litotes:Consider using 'ignored' instead of 'not consider'
    test.txt:13:1:vale.Litotes:Consider using 'ignored' instead of 'not considered'
    test.txt:14:1:vale.Litotes:Consider using 'passed' instead of 'not fail'
    test.txt:15:1:vale.Litotes:Consider using 'lack(s)' instead of 'not have'
    test.txt:16:1:vale.Litotes:Consider using 'few' instead of 'not many'
    test.txt:17:1:vale.Litotes:Consider using 'too young' instead of 'not old enough'
    test.txt:18:1:vale.Litotes:Consider using 'forgot' instead of 'not remember'
    test.txt:19:1:vale.Litotes:Consider using 'failed' instead of 'not succeed'
    test.txt:20:1:vale.Litotes:Consider using 'dumb' instead of 'not the brightest'
    test.txt:21:1:vale.Litotes:Consider using 'different' instead of 'not the same'
    test.txt:22:1:vale.Litotes:Consider using 'aware' instead of 'not unaware'
    test.txt:23:1:vale.Litotes:Consider using 'clean' instead of 'not unclean'
    test.txt:24:1:vale.Litotes:Consider using 'familiar' instead of 'not unfamiliar'
    test.txt:25:1:vale.Litotes:Consider using 'like' instead of 'not unlike'
    test.txt:26:1:vale.Litotes:Consider using 'pleasant' instead of 'not unpleasant'
    test.txt:27:1:vale.Litotes:Consider using 'useful' instead of 'not useless'
    test.txt:28:1:vale.Litotes:Consider using 'right' instead of 'not wrong'
    """

  Scenario: Annotations (rule)
    When I test rule "Annotations"
    Then the output should contain exactly:
    """
    test.txt:1:1:vale.Annotations:'XXX' left in text
    test.txt:2:1:vale.Annotations:'FIXME' left in text
    test.txt:3:1:vale.Annotations:'TODO' left in text
    test.txt:4:1:vale.Annotations:'NOTE' left in text
    """

  Scenario: ComplexWords (rule)
    When I test rule "ComplexWords"
    Then the output should contain exactly:
    """
    test.txt:1:1:vale.ComplexWords:Consider using 'about' instead of 'approximate'
    test.txt:2:1:vale.ComplexWords:Consider using 'about' instead of 'approximately'
    test.txt:3:1:vale.ComplexWords:Consider using 'none' or 'not here' instead of 'absent'
    test.txt:4:1:vale.ComplexWords:Consider using 'plenty' instead of 'abundance'
    test.txt:5:1:vale.ComplexWords:Consider using 'speed up' instead of 'accelerate'
    test.txt:6:1:vale.ComplexWords:Consider using 'stress' instead of 'accentuate'
    test.txt:7:1:vale.ComplexWords:Consider using 'go with' instead of 'accompany'
    test.txt:8:1:vale.ComplexWords:Consider using 'carry out' or 'do' instead of 'accomplish'
    test.txt:9:1:vale.ComplexWords:Consider using 'given' instead of 'accorded'
    test.txt:10:1:vale.ComplexWords:Consider using 'so' instead of 'accordingly'
    test.txt:11:1:vale.ComplexWords:Consider using 'add' instead of 'accrue'
    test.txt:12:1:vale.ComplexWords:Consider using 'right' or 'exact' instead of 'accurate'
    test.txt:13:1:vale.ComplexWords:Consider using 'agree' instead of 'acquiesce'
    test.txt:14:1:vale.ComplexWords:Consider using 'get' or 'buy' instead of 'acquire'
    test.txt:15:1:vale.ComplexWords:Consider using 'more' or 'extra' instead of 'additional'
    test.txt:16:1:vale.ComplexWords:Consider using 'discuss' instead of 'address'
    test.txt:17:1:vale.ComplexWords:Consider using 'you' instead of 'addressees'
    test.txt:18:1:vale.ComplexWords:Consider using 'next to' instead of 'adjacent to'
    test.txt:19:1:vale.ComplexWords:Consider using 'change' instead of 'adjustment'
    test.txt:20:1:vale.ComplexWords:Consider using 'allowed' instead of 'admissible'
    test.txt:21:1:vale.ComplexWords:Consider using 'helpful' instead of 'advantageous'
    test.txt:22:1:vale.ComplexWords:Consider using 'tell' instead of 'advise'
    test.txt:23:1:vale.ComplexWords:Consider using 'total' instead of 'aggregate'
    test.txt:24:1:vale.ComplexWords:Consider using 'plane' instead of 'aircraft'
    test.txt:25:1:vale.ComplexWords:Consider using 'ease' instead of 'alleviate'
    test.txt:26:1:vale.ComplexWords:Consider using 'assign' or 'divide' instead of 'allocate'
    test.txt:27:1:vale.ComplexWords:Consider using 'or' instead of 'alternatively'
    test.txt:28:1:vale.ComplexWords:Consider using 'choices' or 'options' instead of 'alternatives'
    test.txt:29:1:vale.ComplexWords:Consider using 'improve' instead of 'ameliorate'
    test.txt:30:1:vale.ComplexWords:Consider using 'change' instead of 'amend'
    test.txt:31:1:vale.ComplexWords:Consider using 'expect' instead of 'anticipate'
    test.txt:32:1:vale.ComplexWords:Consider using 'clear' or 'plain' instead of 'apparent'
    test.txt:33:1:vale.ComplexWords:Consider using 'discover' or 'find out' instead of 'ascertain'
    test.txt:34:1:vale.ComplexWords:Consider using 'help' instead of 'assistance'
    test.txt:35:1:vale.ComplexWords:Consider using 'meet' instead of 'attain'
    test.txt:36:1:vale.ComplexWords:Consider using 'try' instead of 'attempt'
    test.txt:37:1:vale.ComplexWords:Consider using 'allow' instead of 'authorize'
    test.txt:38:1:vale.ComplexWords:Consider using 'late' instead of 'belated'
    test.txt:39:1:vale.ComplexWords:Consider using 'give' instead of 'bestow'
    test.txt:40:1:vale.ComplexWords:Consider using 'stop' or 'end' instead of 'cease'
    test.txt:41:1:vale.ComplexWords:Consider using 'work together' instead of 'collaborate'
    test.txt:42:1:vale.ComplexWords:Consider using 'begin' instead of 'commence'
    test.txt:43:1:vale.ComplexWords:Consider using 'pay' instead of 'compensate'
    test.txt:44:1:vale.ComplexWords:Consider using 'part' instead of 'component'
    test.txt:45:1:vale.ComplexWords:Consider using 'form' or 'include' instead of 'comprise'
    test.txt:46:1:vale.ComplexWords:Consider using 'idea' instead of 'concept'
    test.txt:47:1:vale.ComplexWords:Consider using 'about' instead of 'concerning'
    test.txt:48:1:vale.ComplexWords:Consider using 'give' or 'award' instead of 'confer'
    test.txt:49:1:vale.ComplexWords:Consider using 'so' instead of 'consequently'
    test.txt:50:1:vale.ComplexWords:Consider using 'merge' instead of 'consolidate'
    test.txt:51:1:vale.ComplexWords:Consider using 'forms' instead of 'constitutes'
    test.txt:52:1:vale.ComplexWords:Consider using 'has' instead of 'contains'
    test.txt:53:1:vale.ComplexWords:Consider using 'meet' instead of 'convene'
    test.txt:54:1:vale.ComplexWords:Consider using 'show' or 'prove' instead of 'demonstrate'
    test.txt:55:1:vale.ComplexWords:Consider using 'leave' instead of 'depart'
    test.txt:56:1:vale.ComplexWords:Consider using 'choose' instead of 'designate'
    test.txt:57:1:vale.ComplexWords:Consider using 'want' or 'wish' instead of 'desire'
    test.txt:58:1:vale.ComplexWords:Consider using 'decide' or 'find' instead of 'determine'
    test.txt:59:1:vale.ComplexWords:Consider using 'bad' or 'harmful' instead of 'detrimental'
    test.txt:60:1:vale.ComplexWords:Consider using 'share' or 'tell' instead of 'disclose'
    test.txt:61:1:vale.ComplexWords:Consider using 'stop' instead of 'discontinue'
    test.txt:62:1:vale.ComplexWords:Consider using 'send' or 'give' instead of 'disseminate'
    test.txt:63:1:vale.ComplexWords:Consider using 'end' instead of 'eliminate'
    test.txt:64:1:vale.ComplexWords:Consider using 'explain' instead of 'elucidate'
    test.txt:65:1:vale.ComplexWords:Consider using 'use' instead of 'employ'
    test.txt:66:1:vale.ComplexWords:Consider using inside or 'included' instead of 'enclosed'
    test.txt:67:1:vale.ComplexWords:Consider using 'meet' instead of 'encounter'
    test.txt:68:1:vale.ComplexWords:Consider using 'try' instead of 'endeavor'
    test.txt:69:1:vale.ComplexWords:Consider using 'count' instead of 'enumerate'
    test.txt:70:1:vale.ComplexWords:Consider using 'fair' instead of 'equitable'
    test.txt:71:1:vale.ComplexWords:Consider using 'equal' instead of 'equivalent'
    test.txt:72:1:vale.ComplexWords:Consider using 'only' instead of 'exclusively'
    test.txt:73:1:vale.ComplexWords:Consider using 'hurry' instead of 'expedite'
    test.txt:74:1:vale.ComplexWords:Consider using 'ease' instead of 'facilitate'
    test.txt:75:1:vale.ComplexWords:Consider using 'women' instead of 'females'
    test.txt:76:1:vale.ComplexWords:Consider using 'complete' or finish instead of 'finalize'
    test.txt:77:1:vale.ComplexWords:Consider using 'often' instead of 'frequently'
    test.txt:78:1:vale.ComplexWords:Consider using 'same' instead of 'identical'
    test.txt:79:1:vale.ComplexWords:Consider using 'wrong' instead of 'incorrect'
    test.txt:80:1:vale.ComplexWords:Consider using 'sign' instead of 'indication'
    test.txt:81:1:vale.ComplexWords:Consider using 'listed' instead of 'itemized'
    test.txt:82:1:vale.ComplexWords:Consider using 'risk' instead of 'jeopardize'
    test.txt:83:1:vale.ComplexWords:Consider using 'keep' or 'support' instead of 'maintain'
    test.txt:84:1:vale.ComplexWords:Consider using 'method' instead of 'methodology'
    test.txt:85:1:vale.ComplexWords:Consider using 'change' instead of 'modify'
    test.txt:86:1:vale.ComplexWords:Consider using 'check' or 'watch' instead of 'monitor'
    test.txt:87:1:vale.ComplexWords:Consider using 'many' instead of 'multiple'
    test.txt:88:1:vale.ComplexWords:Consider using 'cause' instead of 'necessitate'
    test.txt:89:1:vale.ComplexWords:Consider using 'tell' instead of 'notify'
    test.txt:90:1:vale.ComplexWords:Consider using 'many' instead of 'numerous'
    test.txt:91:1:vale.ComplexWords:Consider using 'aim' or 'goal' instead of 'objective'
    test.txt:92:1:vale.ComplexWords:Consider using 'bind' or 'compel' instead of 'obligate'
    test.txt:93:1:vale.ComplexWords:Consider using 'best' or 'most' instead of 'optimum'
    test.txt:94:1:vale.ComplexWords:Consider using 'let' instead of 'permit'
    test.txt:95:1:vale.ComplexWords:Consider using 'part' instead of 'portion'
    test.txt:96:1:vale.ComplexWords:Consider using 'own' instead of 'possess'
    test.txt:97:1:vale.ComplexWords:Consider using 'earlier' instead of 'previous'
    test.txt:98:1:vale.ComplexWords:Consider using 'before' instead of 'previously'
    test.txt:99:1:vale.ComplexWords:Consider using 'rank' instead of 'prioritize'
    test.txt:100:1:vale.ComplexWords:Consider using 'buy' instead of 'procure'
    test.txt:101:1:vale.ComplexWords:Consider using 'give' or 'offer' instead of 'provide'
    test.txt:102:1:vale.ComplexWords:Consider using 'buy' instead of 'purchase'
    test.txt:103:1:vale.ComplexWords:Consider using 'move' instead of 'relocate'
    test.txt:104:1:vale.ComplexWords:Consider using 'ask' instead of 'request'
    test.txt:105:1:vale.ComplexWords:Consider using 'request' instead of 'solicit'
    test.txt:106:1:vale.ComplexWords:Consider using 'latest' instead of 'state-of-the-art'
    test.txt:107:1:vale.ComplexWords:Consider using 'later' or 'next' instead of 'subsequent'
    test.txt:108:1:vale.ComplexWords:Consider using 'large' instead of 'substantial'
    test.txt:109:1:vale.ComplexWords:Consider using 'enough' instead of 'sufficient'
    test.txt:110:1:vale.ComplexWords:Consider using 'end' instead of 'terminate'
    test.txt:111:1:vale.ComplexWords:Consider using 'send' instead of 'transmit'
    test.txt:112:1:vale.ComplexWords:Consider using 'use' instead of 'utilization'
    test.txt:113:1:vale.ComplexWords:Consider using 'use' instead of 'utilize'
    """

  Scenario: Editorializing (rule)
    When I test rule "Editorializing"
    Then the output should contain exactly:
    """
    test.txt:1:1:vale.Editorializing:Consider removing 'actually'
    test.txt:2:1:vale.Editorializing:Consider removing 'aptly'
    test.txt:3:1:vale.Editorializing:Consider removing 'are a number'
    test.txt:4:1:vale.Editorializing:Consider removing 'clearly'
    test.txt:5:1:vale.Editorializing:Consider removing 'completely'
    test.txt:6:1:vale.Editorializing:Consider removing 'essentially'
    test.txt:7:1:vale.Editorializing:Consider removing 'exceedingly'
    test.txt:8:1:vale.Editorializing:Consider removing 'excellent'
    test.txt:9:1:vale.Editorializing:Consider removing 'extremely'
    test.txt:10:1:vale.Editorializing:Consider removing 'fairly'
    test.txt:11:1:vale.Editorializing:Consider removing 'fortunately'
    test.txt:12:1:vale.Editorializing:Consider removing 'huge'
    test.txt:13:1:vale.Editorializing:Consider removing 'interestingly'
    test.txt:14:1:vale.Editorializing:Consider removing 'is a number'
    test.txt:15:1:vale.Editorializing:Consider removing 'it is important to realize'
    test.txt:16:1:vale.Editorializing:Consider removing 'it should be noted that'
    test.txt:17:1:vale.Editorializing:Consider removing 'largely'
    test.txt:18:1:vale.Editorializing:Consider removing 'mostly'
    test.txt:19:1:vale.Editorializing:Consider removing 'notably'
    test.txt:20:1:vale.Editorializing:Consider removing 'note that'
    test.txt:21:1:vale.Editorializing:Consider removing 'obviously'
    test.txt:22:1:vale.Editorializing:Consider removing 'of course'
    test.txt:23:1:vale.Editorializing:Consider removing 'quite'
    test.txt:24:1:vale.Editorializing:Consider removing 'relatively'
    test.txt:25:1:vale.Editorializing:Consider removing 'remarkably'
    test.txt:26:1:vale.Editorializing:Consider removing 'several'
    test.txt:27:1:vale.Editorializing:Consider removing 'significantly'
    test.txt:28:1:vale.Editorializing:Consider removing 'substantially'
    test.txt:29:1:vale.Editorializing:Consider removing 'surprisingly'
    test.txt:30:1:vale.Editorializing:Consider removing 'tiny'
    test.txt:31:1:vale.Editorializing:Consider removing 'totally'
    test.txt:32:3:vale.Editorializing:Consider removing 'tragically'
    test.txt:33:3:vale.Editorializing:Consider removing 'unfortunately'
    test.txt:34:3:vale.Editorializing:Consider removing 'untimely'
    test.txt:35:3:vale.Editorializing:Consider removing 'various'
    test.txt:36:3:vale.Editorializing:Consider removing 'vast'
    test.txt:37:3:vale.Editorializing:Consider removing 'very'
    test.txt:38:3:vale.Editorializing:Consider removing 'without a doubt'
    """

  Scenario: Hedging (rule)
    When I test rule "Hedging"
    Then the output should contain exactly:
    """
    test.txt:1:1:vale.Hedging:Consider removing 'appear to be'
    test.txt:2:1:vale.Hedging:Consider removing 'arguably'
    test.txt:3:1:vale.Hedging:Consider removing 'as far as I know'
    test.txt:4:1:vale.Hedging:Consider removing 'could'
    test.txt:5:1:vale.Hedging:Consider removing 'from my point of view'
    test.txt:6:1:vale.Hedging:Consider removing 'I believe'
    test.txt:7:1:vale.Hedging:Consider removing 'I doubt'
    test.txt:8:1:vale.Hedging:Consider removing 'I think'
    test.txt:9:1:vale.Hedging:Consider removing 'in general'
    test.txt:10:1:vale.Hedging:Consider removing 'In my opinion'
    test.txt:11:1:vale.Hedging:Consider removing 'likely'
    test.txt:12:1:vale.Hedging:Consider removing 'might'
    test.txt:13:1:vale.Hedging:Consider removing 'more or less'
    test.txt:14:1:vale.Hedging:Consider removing 'perhaps'
    test.txt:15:1:vale.Hedging:Consider removing 'possibly'
    test.txt:16:1:vale.Hedging:Consider removing 'presumably'
    test.txt:17:1:vale.Hedging:Consider removing 'probably'
    test.txt:18:1:vale.Hedging:Consider removing 'seem'
    test.txt:19:1:vale.Hedging:Consider removing 'seems'
    test.txt:20:1:vale.Hedging:Consider removing 'somewhat'
    test.txt:21:1:vale.Hedging:Consider removing 'to my knowledge'
    test.txt:22:1:vale.Hedging:Consider removing 'unlikely'
    test.txt:23:1:vale.Hedging:Consider removing 'usually'
    """

  Scenario: Redundancy (rule)
    When I test rule "Redundancy"
    Then the output should contain exactly:
    """
    test.txt:1:1:vale.Redundancy:'added bonus' is redundant
    test.txt:2:1:vale.Redundancy:'extra bonus' is redundant
    test.txt:3:1:vale.Redundancy:'advance notice' is redundant
    test.txt:4:1:vale.Redundancy:'prior notice' is redundant
    test.txt:5:1:vale.Redundancy:'gather together' is redundant
    test.txt:6:1:vale.Redundancy:'assemble together' is redundant
    test.txt:7:1:vale.Redundancy:'attach together' is redundant
    test.txt:8:1:vale.Redundancy:'blend together' is redundant
    test.txt:9:1:vale.Redundancy:'mix together' is redundant
    test.txt:10:1:vale.Redundancy:'combine together' is redundant
    test.txt:11:1:vale.Redundancy:'collaborate together' is redundant
    test.txt:12:1:vale.Redundancy:'connect together' is redundant
    test.txt:13:1:vale.Redundancy:'cooperate together' is redundant
    test.txt:14:1:vale.Redundancy:'terrible tragedy' is redundant
    test.txt:15:1:vale.Redundancy:'horrible tragedy' is redundant
    test.txt:16:1:vale.Redundancy:'ABM missile' is redundant
    test.txt:17:1:vale.Redundancy:'ABM missiles' is redundant
    test.txt:18:1:vale.Redundancy:'ABS braking system' is redundant
    test.txt:19:1:vale.Redundancy:'absolutely necessary' is redundant
    test.txt:20:1:vale.Redundancy:'absolutely essential' is redundant
    test.txt:21:1:vale.Redundancy:'ACT test' is redundant
    test.txt:22:1:vale.Redundancy:'already existing' is redundant
    test.txt:23:1:vale.Redundancy:'armed gunman' is redundant
    test.txt:24:1:vale.Redundancy:'artificial prosthesis' is redundant
    test.txt:25:1:vale.Redundancy:'ATM machine' is redundant
    test.txt:26:1:vale.Redundancy:'bald-headed' is redundant
    test.txt:27:1:vale.Redundancy:'brief moment' is redundant
    test.txt:28:1:vale.Redundancy:'brief summary' is redundant
    test.txt:29:1:vale.Redundancy:'CD disc' is redundant
    test.txt:30:1:vale.Redundancy:'cease and desist' is redundant
    test.txt:31:1:vale.Redundancy:'circle around' is redundant
    test.txt:32:1:vale.Redundancy:'close proximity' is redundant
    test.txt:33:1:vale.Redundancy:'closed fist' is redundant
    test.txt:34:1:vale.Redundancy:'completely destroyed' is redundant
    test.txt:35:1:vale.Redundancy:'completely eliminate' is redundant
    test.txt:36:1:vale.Redundancy:'completely engulfed' is redundant
    test.txt:37:1:vale.Redundancy:'completely filled' is redundant
    test.txt:38:1:vale.Redundancy:'completely surround' is redundant
    test.txt:39:1:vale.Redundancy:'could possibly' is redundant
    test.txt:40:1:vale.Redundancy:'CPI Index' is redundant
    test.txt:41:1:vale.Redundancy:'current trend' is redundant
    test.txt:42:1:vale.Redundancy:'end result' is redundant
    test.txt:43:1:vale.Redundancy:'enter in' is redundant
    test.txt:44:1:vale.Redundancy:'erode away' is redundant
    test.txt:45:1:vale.Redundancy:'false pretense' is redundant
    test.txt:46:1:vale.Redundancy:'final result' is redundant
    test.txt:47:1:vale.Redundancy:'free gift' is redundant
    test.txt:48:1:vale.Redundancy:'GPS system' is redundant
    test.txt:49:1:vale.Redundancy:'GUI interface' is redundant
    test.txt:50:1:vale.Redundancy:'HIV virus' is redundant
    test.txt:51:1:vale.Redundancy:'inner feelings' is redundant
    test.txt:52:1:vale.Redundancy:'ISBN number' is redundant
    test.txt:53:1:vale.Redundancy:'join together' is redundant
    test.txt:54:1:vale.Redundancy:'LCD display' is redundant
    test.txt:55:1:vale.Redundancy:'local resident' is redundant
    test.txt:56:1:vale.Redundancy:'local residents' is redundant
    test.txt:57:1:vale.Redundancy:'natural instinct' is redundant
    test.txt:58:1:vale.Redundancy:'new invention' is redundant
    test.txt:59:1:vale.Redundancy:'null and void' is redundant
    test.txt:60:1:vale.Redundancy:'past history' is redundant
    test.txt:61:1:vale.Redundancy:'PDF format' is redundant
    test.txt:62:1:vale.Redundancy:'PIN number' is redundant
    test.txt:63:1:vale.Redundancy:'please RSVP' is redundant
    test.txt:64:1:vale.Redundancy:'RAM memory' is redundant
    test.txt:65:1:vale.Redundancy:'RAS syndrome' is redundant
    test.txt:66:1:vale.Redundancy:'RIP in peace' is redundant
    test.txt:67:1:vale.Redundancy:'safe haven' is redundant
    test.txt:68:1:vale.Redundancy:'SALT talks' is redundant
    test.txt:69:1:vale.Redundancy:'SAT test' is redundant
    test.txt:70:1:vale.Redundancy:'shout loudly' is redundant
    test.txt:71:1:vale.Redundancy:'surrounded on all sides' is redundant
    test.txt:72:1:vale.Redundancy:'undergraduate student' is redundant
    test.txt:73:1:vale.Redundancy:'unexpected surprise' is redundant
    test.txt:74:1:vale.Redundancy:'unintended mistake' is redundant
    test.txt:75:1:vale.Redundancy:'UPC code' is redundant
    test.txt:76:1:vale.Redundancy:'UPC codes' is redundant
    test.txt:77:1:vale.Redundancy:'violent explosion' is redundant
    """

  Scenario: GenderBias (rule)
    When I test rule "GenderBias"
    Then the output should contain exactly:
    """
    test.txt:1:1:vale.GenderBias:Consider using 'graduate' instead of 'alumna'
    test.txt:2:1:vale.GenderBias:Consider using 'graduate' instead of 'alumnus'
    test.txt:3:1:vale.GenderBias:Consider using 'graduates' instead of 'alumnae'
    test.txt:4:1:vale.GenderBias:Consider using 'graduates' instead of 'alumni'
    test.txt:5:1:vale.GenderBias:Consider using 'native land' instead of 'motherland'
    test.txt:6:1:vale.GenderBias:Consider using 'native land' instead of 'fatherland'
    test.txt:7:1:vale.GenderBias:Consider using 'native tongue' instead of 'mothertongue'
    test.txt:8:1:vale.GenderBias:Consider using 'pilot(s)' instead of 'airmen'
    test.txt:9:1:vale.GenderBias:Consider using 'pilot(s)' instead of 'airman'
    test.txt:10:1:vale.GenderBias:Consider using 'pilot(s)' instead of 'airwomen'
    test.txt:11:1:vale.GenderBias:Consider using 'pilot(s)' instead of 'airwoman'
    test.txt:12:1:vale.GenderBias:Consider using 'anchor(s)' instead of 'anchormen'
    test.txt:13:1:vale.GenderBias:Consider using 'anchor(s)' instead of 'anchorman'
    test.txt:14:1:vale.GenderBias:Consider using 'anchor(s)' instead of 'anchorwomen'
    test.txt:15:1:vale.GenderBias:Consider using 'anchor(s)' instead of 'anchorwoman'
    test.txt:16:1:vale.GenderBias:Consider using 'author' instead of 'authoress'
    test.txt:17:1:vale.GenderBias:Consider using 'camera operator(s)' instead of 'cameramen'
    test.txt:18:1:vale.GenderBias:Consider using 'camera operator(s)' instead of 'cameraman'
    test.txt:19:1:vale.GenderBias:Consider using 'camera operator(s)' instead of 'camerawomen'
    test.txt:20:1:vale.GenderBias:Consider using 'camera operator(s)' instead of 'camerawoman'
    test.txt:21:1:vale.GenderBias:Consider using 'chair(s)' instead of 'chairmen'
    test.txt:22:1:vale.GenderBias:Consider using 'chair(s)' instead of 'chairman'
    test.txt:23:1:vale.GenderBias:Consider using 'chair(s)' instead of 'chairwomen'
    test.txt:24:1:vale.GenderBias:Consider using 'chair(s)' instead of 'chairwoman'
    test.txt:25:1:vale.GenderBias:Consider using 'member(s) of congress' instead of 'congressmen'
    test.txt:26:1:vale.GenderBias:Consider using 'member(s) of congress' instead of 'congressman'
    test.txt:27:1:vale.GenderBias:Consider using 'member(s) of congress' instead of 'congresswomen'
    test.txt:28:1:vale.GenderBias:Consider using 'member(s) of congress' instead of 'congresswoman'
    test.txt:29:1:vale.GenderBias:Consider using 'concierge(s)' instead of 'doormen'
    test.txt:30:1:vale.GenderBias:Consider using 'concierge(s)' instead of 'doorman'
    test.txt:31:1:vale.GenderBias:Consider using 'concierge(s)' instead of 'doorwomen'
    test.txt:32:1:vale.GenderBias:Consider using 'concierge(s)' instead of 'doorwoman'
    test.txt:33:1:vale.GenderBias:Consider using 'drafter(s)' instead of 'draftsmen'
    test.txt:34:1:vale.GenderBias:Consider using 'drafter(s)' instead of 'draftsman'
    test.txt:35:1:vale.GenderBias:Consider using 'drafter(s)' instead of 'draftswomen'
    test.txt:36:1:vale.GenderBias:Consider using 'drafter(s)' instead of 'draftswoman'
    test.txt:37:1:vale.GenderBias:Consider using 'firefighter(s)' instead of 'firemen'
    test.txt:38:1:vale.GenderBias:Consider using 'firefighter(s)' instead of 'fireman'
    test.txt:39:1:vale.GenderBias:Consider using 'firefighter(s)' instead of 'firewomen'
    test.txt:40:1:vale.GenderBias:Consider using 'firefighter(s)' instead of 'firewoman'
    test.txt:41:1:vale.GenderBias:Consider using 'fisher(s)' instead of 'fishermen'
    test.txt:42:1:vale.GenderBias:Consider using 'fisher(s)' instead of 'fisherman'
    test.txt:43:1:vale.GenderBias:Consider using 'fisher(s)' instead of 'fisherwomen'
    test.txt:44:1:vale.GenderBias:Consider using 'fisher(s)' instead of 'fisherwoman'
    test.txt:45:1:vale.GenderBias:Consider using 'first-year student(s)' instead of 'freshmen'
    test.txt:46:1:vale.GenderBias:Consider using 'first-year student(s)' instead of 'freshman'
    test.txt:47:1:vale.GenderBias:Consider using 'waste collector(s)' instead of 'garbagemen'
    test.txt:48:1:vale.GenderBias:Consider using 'waste collector(s)' instead of 'garbageman'
    test.txt:49:1:vale.GenderBias:Consider using 'waste collector(s)' instead of 'garbagewomen'
    test.txt:50:1:vale.GenderBias:Consider using 'waste collector(s)' instead of 'garbagewoman'
    test.txt:51:1:vale.GenderBias:Consider using 'everyone' instead of 'guys'
    test.txt:52:1:vale.GenderBias:Consider using 'lawyer' instead of 'lady lawyer'
    test.txt:53:1:vale.GenderBias:Consider using 'courteous' instead of 'ladylike'
    test.txt:54:1:vale.GenderBias:Consider using 'building manager' instead of 'landlord'
    test.txt:55:1:vale.GenderBias:Consider using 'mail carriers' instead of 'mailman'
    test.txt:56:1:vale.GenderBias:Consider using 'mail carriers' instead of 'mailmen'
    test.txt:57:1:vale.GenderBias:Consider using 'mail carriers' instead of 'mailwomen'
    test.txt:58:1:vale.GenderBias:Consider using 'mail carriers' instead of 'mailwoman'
    test.txt:59:1:vale.GenderBias:Consider using 'husband and wife' instead of 'man and wife'
    test.txt:60:1:vale.GenderBias:Consider using 'strong enough' instead of 'man enough'
    test.txt:61:1:vale.GenderBias:Consider using 'human kind' instead of 'mankind'
    test.txt:62:1:vale.GenderBias:Consider using 'human resources' instead of 'manpower'
    test.txt:63:1:vale.GenderBias:Consider using 'manufactured' instead of 'manmade'
    test.txt:64:1:vale.GenderBias:Consider using 'men and women' instead of 'men and girls'
    test.txt:65:1:vale.GenderBias:Consider using 'intermediary' instead of 'middleman'
    test.txt:66:1:vale.GenderBias:Consider using 'intermediary' instead of 'middlemen'
    test.txt:67:1:vale.GenderBias:Consider using 'intermediary' instead of 'middlewoman'
    test.txt:68:1:vale.GenderBias:Consider using 'intermediary' instead of 'middlewomen'
    test.txt:69:1:vale.GenderBias:Consider using 'journalist(s)' instead of 'newsman'
    test.txt:70:1:vale.GenderBias:Consider using 'journalist(s)' instead of 'newsmen'
    test.txt:71:1:vale.GenderBias:Consider using 'journalist(s)' instead of 'newswoman'
    test.txt:72:1:vale.GenderBias:Consider using 'journalist(s)' instead of 'newswomen'
    test.txt:73:1:vale.GenderBias:Consider using 'ombuds' instead of 'ombudsman'
    test.txt:74:1:vale.GenderBias:Consider using 'ombuds' instead of 'ombudswoman'
    test.txt:75:1:vale.GenderBias:Consider using 'upstaging' instead of 'oneupmanship'
    test.txt:76:1:vale.GenderBias:Consider using 'poet' instead of 'poetess'
    test.txt:77:1:vale.GenderBias:Consider using 'police officer(s)' instead of 'policeman'
    test.txt:78:1:vale.GenderBias:Consider using 'police officer(s)' instead of 'policemen'
    test.txt:79:1:vale.GenderBias:Consider using 'police officer(s)' instead of 'policewomen'
    test.txt:80:1:vale.GenderBias:Consider using 'police officer(s)' instead of 'policewoman'
    test.txt:81:1:vale.GenderBias:Consider using 'technician(s)' instead of 'repairman'
    test.txt:82:1:vale.GenderBias:Consider using 'technician(s)' instead of 'repairmen'
    test.txt:83:1:vale.GenderBias:Consider using 'technician(s)' instead of 'repairwomen'
    test.txt:84:1:vale.GenderBias:Consider using 'technician(s)' instead of 'repairwoman'
    test.txt:85:1:vale.GenderBias:Consider using 'salesperson or sales people' instead of 'salesman'
    test.txt:86:1:vale.GenderBias:Consider using 'salesperson or sales people' instead of 'salesmen'
    test.txt:87:1:vale.GenderBias:Consider using 'salesperson or sales people' instead of 'saleswomen'
    test.txt:88:1:vale.GenderBias:Consider using 'salesperson or sales people' instead of 'saleswoman'
    test.txt:89:1:vale.GenderBias:Consider using 'soldier(s)' instead of 'serviceman'
    test.txt:90:1:vale.GenderBias:Consider using 'soldier(s)' instead of 'servicemen'
    test.txt:91:1:vale.GenderBias:Consider using 'soldier(s)' instead of 'servicewoman'
    test.txt:92:1:vale.GenderBias:Consider using 'soldier(s)' instead of 'servicewomen'
    test.txt:93:1:vale.GenderBias:Consider using 'flight attendant' instead of 'steward'
    test.txt:94:1:vale.GenderBias:Consider using 'flight attendant' instead of 'stewardess'
    test.txt:95:1:vale.GenderBias:Consider using 'tribe member(s)' instead of 'tribesman'
    test.txt:96:1:vale.GenderBias:Consider using 'tribe member(s)' instead of 'tribesmen'
    test.txt:97:1:vale.GenderBias:Consider using 'tribe member(s)' instead of 'tribeswomen'
    test.txt:98:1:vale.GenderBias:Consider using 'tribe member(s)' instead of 'tribeswoman'
    test.txt:99:1:vale.GenderBias:Consider using 'waiter' instead of 'waitress'
    test.txt:100:1:vale.GenderBias:Consider using 'doctor' instead of 'woman doctor'
    test.txt:101:1:vale.GenderBias:Consider using 'scientist(s)' instead of 'woman scientist'
    test.txt:102:1:vale.GenderBias:Consider using 'scientist(s)' instead of 'woman scientists'
    test.txt:103:1:vale.GenderBias:Consider using 'worker(s)' instead of 'workman'
    test.txt:104:1:vale.GenderBias:Consider using 'worker(s)' instead of 'workmen'
    test.txt:105:1:vale.GenderBias:Consider using 'worker(s)' instead of 'workwoman'
    test.txt:106:1:vale.GenderBias:Consider using 'worker(s)' instead of 'workwomen'
    """
