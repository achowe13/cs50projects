from cs50 import get_string


# initialize variables (must add 1 to word count because always 1 more word that spaces(starts with word and ends with word))
letters = 0
words = 1
sentences = 0

# get text from user
text = get_string("enter text: \n")

# loop through checking every variable in text
for i in range(len(text)):
    # count letters in text
    if text[i].isalpha():
        letters += 1
    # count spaces indicating word count
    if text[i] == ' ':
        words += 1
    # count sentence ending punctuation indicating sentence count
    if text[i] == '.' or text[i] == '?' or text[i] == '!':
        sentences += 1

# calculate grade level based on equasion
L = (float(letters) / float(words)) * 100

S = (float(sentences) / float(words)) * 100

grade_level = round((0.0588 * L - 0.296 * S - 15.8))

# print grade level
if grade_level > 16:
    print("Grade 16+\n")
elif grade_level < 1:
    print("Before Grade 1\n")
else:
    print(f"Grade {grade_level}\n")