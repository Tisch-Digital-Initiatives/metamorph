class Interface:
    _log = ""
    
    def __init__(self):
        pass
    
    def __str__(self):
        return('Text Interface')
    
    def log(self, text):
        self._log += text
        print(text)
    
    def getlog(self):
        return self._log
    
    def clearlog(self):
        self._log = ""
    
    def message(self, text):
        if isinstance(text, list):
            output = ''
            for i in text:
                output = ' '.join([output, str(i)])
        else: 
            output = str(text)
        print(output)
    
    def question(self, text, prompt=''):
        if len(text) > 0:
            self.message(text)
            return input(prompt)
    
    def yesno(self, text, default=''):
        default = default.lower()
        if default == 'y' or default == 'n':
            prompt = ''.join(['(y or n, blank=', default, '?): '])
        else:
            prompt = '(y or n): '
        input = self.question(text, prompt).strip().lower()
        while True:
            if input == 'y' or input == 'yes':
                return True
            if input == 'n' or input == 'no':
                return False
            if input == '':
                if default == 'y' or default == 'yes':
                    return True
                if default == 'n' or default == 'no':
                    return False
            input = self.question(text, prompt).lower()
    
    def multiple_choice(self, text, choices):
        self.message('')
        self.message(text)
        for entry in choices:
            self.message([' *', str(entry)])
        while True:
            self.message('')
            choice = ''
            while choice == '':
                choice = self.question('Enter at least the first few letters of your choice:')
            result = ''
            for entry in choices:
                if str(entry).lower().startswith(choice):
                    result = entry
                    break
            self.message('')
            if result == '':
                self.message('Choice not recognized')
            elif self.yesno(['You chose: ', result,': Confirm?'], 'y'):
                return(result)


if __name__ == '__main__':
    ui = Interface()
    ui.message('testing message()')
    answer = ui.question('what is your quest?', '>> ')
    ui.message(['the answer is: ', answer])
    answer = ui.yesno('do you like ice cream?', 'y')
    ui.message(['the answer is: ', str(answer)])
    choices = ['apple', 'orange', 'banana']
    answer = ui.multiple_choice('what fruit do you like?', choices)
    ui.message(['the answer is: ', answer])