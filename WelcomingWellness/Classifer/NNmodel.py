import pandas as pd
import numpy as np
from random import uniform as rnd

from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import NearestNeighbors
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import FunctionTransformer

# import boto3
# s3_obj =boto3.client('s3')
# s3_clientobj = s3_obj.get_object(Bucket='foodcomkaggle', Key='archive/recipes.csv')

DATA_FILE = "Classifer/recipes.csv"
# DATA_FILE = "archive/recipes.csv"
recipes_df = pd.read_csv(DATA_FILE)



recipes_df = recipes_df.dropna()
nutritional_cols = [
    "RecipeId",
    "Name",
    "Calories",
    "FatContent",
    "SaturatedFatContent",
    "CholesterolContent",
    "SodiumContent",
    "CarbohydrateContent",
    "FiberContent",
    "SugarContent",
    "ProteinContent",
    "RecipeServings",
]
cols_to_divide = [
    "Calories",
    "FatContent",
    "SaturatedFatContent",
    "CholesterolContent",
    "SodiumContent",
    "CarbohydrateContent",
    "FiberContent",
    "SugarContent",
    "ProteinContent",
]


def get_nutritional_values(data):
    nutritional_df = data[nutritional_cols]
    # dropping all nonnan values
    nutritional_df = nutritional_df.dropna(axis=0)
    # Divided by the serving size so that calories/ nutrion values are consietent

    nutritional_df[cols_to_divide] = nutritional_df[cols_to_divide].div(
        nutritional_df["RecipeServings"], axis=0
    )
    nutritional_df = nutritional_df.drop("RecipeServings", axis=1)
    return nutritional_df


def filter_restrictions(data, dietary_restrictions):
    data_copy = data.copy()
    filted_data = data_copy[
        ~data_copy["RecipeIngredientParts"].apply(
            lambda x: any(
                ingredient.lower() in x.lower() for ingredient in dietary_restrictions
            )
        )
    ]

    return filted_data


def contains_ingredients(data, ingredients):
    filtered_data = data.copy()

    if ingredients:
        filtered_data = filtered_data[
            filtered_data["RecipeIngredientParts"].apply(
                lambda x: any(
                    ingredient.lower() in x.lower() for ingredient in ingredients
                )
            )
        ]

    return filtered_data


def NNmodel(data):
    model = NearestNeighbors(metric="cosine", algorithm="brute")
    model.fit(data)
    return model


def reccomend(data, input: list(), dietary_restrictions: list(), ingredients: list()):
    filtered_data = filter_restrictions(data, dietary_restrictions)
    relevant = contains_ingredients(filtered_data, ingredients)

    only_nutritional__data = get_nutritional_values(relevant)

    standardized_data, scaler = scaling(only_nutritional__data)
    print(standardized_data)

    model = NNmodel(standardized_data)
    # model.kneighbors(n_neighbors=5)
    pipeline = build_pipeline(model, scaler)

    return apply_pipeline(pipeline, input, only_nutritional__data)


def apply_pipeline(pipeline, _input, extracted_data):
    _input = np.array(_input).reshape(1, -1)
    return extracted_data.iloc[pipeline.transform(_input)[0]]


def build_pipeline(neigh, scaler):
    transformer = FunctionTransformer(
        neigh.kneighbors, kw_args={"n_neighbors": 5, "return_distance": False}
    )
    pipeline = Pipeline([("std_scaler", scaler), ("NN", transformer)])
    return pipeline


# preprocessing
def scaling(data):
    standard_scaler = StandardScaler()
    prep_data = standard_scaler.fit_transform(data.iloc[:, 2:].to_numpy())
    prep_data = pd.DataFrame(
        prep_data, columns=data.columns[2:]
    )  # Exclude recipe names
    # prep_data.insert(0, "RecipeId", data["RecipeId"])  # Include recipe names
    # prep_data.insert(1, "RecipeName", data["Name"])  # Include recipe names

    # print(prep_data.shape)
    return prep_data, standard_scaler

import coremltools
coreml_model = coremltools.converters.sklearn.convert(forest_classifier)
coreml_model.author = “Jason”
    # input['Calories','FatContent','SaturatedFatContent','CholesterolContent','SodiumContent','CarbohydrateContent','FiberContent','SugarContent','ProteinContent']

coreml_model.input_description[“input”] = “An array of 9 doubles — ['Calories','FatContent','SaturatedFatContent','CholesterolContent','SodiumContent','CarbohydrateContent','FiberContent','SugarContent','ProteinContent']”
coreml_model.output_description[“Recipe”] = “A string value”
coreml_model.short_description = “Recipe Reccomender classifier”
coreml_model.save(‘DietRec.mlmodel’)


#if __name__ == "__main__":
#    print("hello")
#    print(
#        reccomend(
#            recipes_df,
#            [
#                20000,
#                rnd(10, 30),
#                rnd(0, 4),
#                rnd(0, 30),
#                rnd(0, 400),
#                rnd(40, 75),
#                rnd(4, 10),
#                rnd(0, 10),
#                rnd(30, 100),
#            ],
#            [],
#            [],
#        )
#    )
    # standardized_data, standard_scaler = scaling(recipes_df)
    # model = KNeighborsClassifier()
    # print(standardized_data)

