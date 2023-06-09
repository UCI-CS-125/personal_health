class CalorieCalculator:
    def __init__(self, gender, weight, height, age, activity):
        self.gender = gender
        self.weight = weight
        self.height = height
        self.age = age
        self.activity = activity

    def calculate_bmr(self):
        if self.gender == "Male":
            bmr = 10 * self.weight + 6.25 * self.height - 5 * self.age + 5
        else:
            bmr = 10 * self.weight + 6.25 * self.height - 5 * self.age - 161
        return bmr

    def calories_calculator(self):
        activities = [
            "Little/no exercise",
            "Light exercise",
            "Moderate exercise (3-5 days/wk)",
            "Very active (6-7 days/wk)",
            "Extra active (very active & physical job)",
        ]
        weights = [1.2, 1.375, 1.55, 1.725, 1.9]
        weight = weights[activities.index(self.activity)]
        maintain_calories = self.calculate_bmr() * weight
        return maintain_calories


# # Example usage
# gender = input("Enter your gender: ")
# weight = float(input("Enter your weight in kg: "))
# height = float(input("Enter your height in cm: "))
# age = int(input("Enter your age in years: "))
# activity = input("Enter your activity level: ")

# calculator = CalorieCalculator(gender, weight, height, age, activity)
# calories = calculator.calories_calculator()
# print("Estimated daily calorie intake: ", calories)
