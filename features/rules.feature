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
    test.txt:1:1:vale.ComplexWords:Consider using 'plenty' instead of 'abundance'
    test.txt:2:1:vale.ComplexWords:Consider using 'speed up' instead of 'accelerate'
    test.txt:3:1:vale.ComplexWords:Consider using 'stress' instead of 'accentuate'
    test.txt:4:1:vale.ComplexWords:Consider using 'go with' instead of 'accompany'
    test.txt:5:1:vale.ComplexWords:Consider using 'do' instead of 'accomplish'
    test.txt:6:1:vale.ComplexWords:Consider using 'given' instead of 'accorded'
    test.txt:7:1:vale.ComplexWords:Consider using 'add' instead of 'accrue'
    test.txt:8:1:vale.ComplexWords:Consider using 'agree' instead of 'acquiesce'
    test.txt:9:1:vale.ComplexWords:Consider using 'get' instead of 'acquire'
    test.txt:10:1:vale.ComplexWords:Consider using 'more' instead of 'additional'
    test.txt:11:1:vale.ComplexWords:Consider using 'change' instead of 'adjustment'
    test.txt:12:1:vale.ComplexWords:Consider using 'allowed' instead of 'admissible'
    test.txt:13:1:vale.ComplexWords:Consider using 'helpful' instead of 'advantageous'
    test.txt:14:1:vale.ComplexWords:Consider using 'tell' instead of 'advise'
    test.txt:15:1:vale.ComplexWords:Consider using 'total' instead of 'aggregate'
    test.txt:16:1:vale.ComplexWords:Consider using 'plane' instead of 'aircraft'
    test.txt:17:1:vale.ComplexWords:Consider using 'ease' instead of 'alleviate'
    test.txt:18:1:vale.ComplexWords:Consider using 'assign' instead of 'allocate'
    test.txt:19:1:vale.ComplexWords:Consider using 'or' instead of 'alternatively'
    test.txt:20:1:vale.ComplexWords:Consider using 'improve' instead of 'ameliorate'
    test.txt:21:1:vale.ComplexWords:Consider using 'expect' instead of 'anticipate'
    test.txt:22:1:vale.ComplexWords:Consider using 'clear' instead of 'apparent'
    test.txt:23:1:vale.ComplexWords:Consider using 'many' instead of 'appreciable'
    test.txt:24:1:vale.ComplexWords:Consider using 'discover' instead of 'ascertain'
    test.txt:25:1:vale.ComplexWords:Consider using 'help' instead of 'assistance'
    test.txt:26:1:vale.ComplexWords:Consider using 'meet' instead of 'attain'
    test.txt:27:1:vale.ComplexWords:Consider using 'allow' instead of 'authorize'
    test.txt:28:1:vale.ComplexWords:Consider using 'late' instead of 'belated'
    test.txt:29:1:vale.ComplexWords:Consider using 'give' instead of 'bestow'
    test.txt:30:1:vale.ComplexWords:Consider using 'stop' instead of 'cease'
    test.txt:31:1:vale.ComplexWords:Consider using 'begin' instead of 'commence'
    test.txt:32:1:vale.ComplexWords:Consider using 'about' instead of 'concerning'
    test.txt:33:1:vale.ComplexWords:Consider using 'so' instead of 'consequently'
    test.txt:34:1:vale.ComplexWords:Consider using 'merge' instead of 'consolidate'
    test.txt:35:1:vale.ComplexWords:Consider using 'forms' instead of 'constitutes'
    test.txt:36:1:vale.ComplexWords:Consider using 'show' instead of 'demonstrate'
    test.txt:37:1:vale.ComplexWords:Consider using 'leave' instead of 'depart'
    test.txt:38:1:vale.ComplexWords:Consider using 'choose' instead of 'designate'
    test.txt:39:1:vale.ComplexWords:Consider using 'stop' instead of 'discontinue'
    test.txt:40:1:vale.ComplexWords:Consider using 'end' instead of 'eliminate'
    test.txt:41:1:vale.ComplexWords:Consider using 'explain' instead of 'elucidate'
    test.txt:42:1:vale.ComplexWords:Consider using 'use' instead of 'employ'
    test.txt:43:1:vale.ComplexWords:Consider using 'try' instead of 'endeavor'
    test.txt:44:1:vale.ComplexWords:Consider using 'count' instead of 'enumerate'
    test.txt:45:1:vale.ComplexWords:Consider using 'fair' instead of 'equitable'
    test.txt:46:1:vale.ComplexWords:Consider using 'equal' instead of 'equivalent'
    test.txt:47:1:vale.ComplexWords:Consider using 'only' instead of 'exclusively'
    test.txt:48:1:vale.ComplexWords:Consider using 'hurry' instead of 'expedite'
    test.txt:49:1:vale.ComplexWords:Consider using 'ease' instead of 'facilitate'
    test.txt:50:1:vale.ComplexWords:Consider using 'method' instead of 'methodology'
    test.txt:51:1:vale.ComplexWords:Consider using 'many' instead of 'multiple'
    test.txt:52:1:vale.ComplexWords:Consider using 'cause' instead of 'necessitate'
    test.txt:53:1:vale.ComplexWords:Consider using 'many' instead of 'numerous'
    test.txt:54:1:vale.ComplexWords:Consider using 'best' instead of 'optimum'
    test.txt:55:1:vale.ComplexWords:Consider using 'part' instead of 'portion'
    test.txt:56:1:vale.ComplexWords:Consider using 'own' instead of 'possess'
    test.txt:57:1:vale.ComplexWords:Consider using 'buy' instead of 'procure'
    test.txt:58:1:vale.ComplexWords:Consider using 'buy' instead of 'purchase'
    test.txt:59:1:vale.ComplexWords:Consider using 'move' instead of 'relocate'
    test.txt:60:1:vale.ComplexWords:Consider using 'request' instead of 'solicit'
    test.txt:61:1:vale.ComplexWords:Consider using 'latest' instead of 'state-of-the-art'
    test.txt:62:1:vale.ComplexWords:Consider using 'large' instead of 'substantial'
    test.txt:63:1:vale.ComplexWords:Consider using 'end' instead of 'terminate'
    test.txt:64:1:vale.ComplexWords:Consider using 'send' instead of 'transmit'
    test.txt:65:1:vale.ComplexWords:Consider using 'use' instead of 'utilization'
    test.txt:66:1:vale.ComplexWords:Consider using 'use' instead of 'utilize'
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
