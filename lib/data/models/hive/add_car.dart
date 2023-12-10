// To parse this JSON data, do
//
//     final addCarModelHive = addCarModelHiveFromJson(jsonString);

import 'dart:convert';

AddCarModelHive addCarModelHiveFromJson(String str) => AddCarModelHive.fromJson(json.decode(str));

String addCarModelHiveToJson(AddCarModelHive data) => json.encode(data.toJson());

class AddCarModelHive {
    StepOne? stepOne;
    StepTwo? stepTwo;
    StepThree? stepThree;

    AddCarModelHive({
        this.stepOne,
        this.stepTwo,
        this.stepThree,
    });

    AddCarModelHive copyWith({
        StepOne? stepOne,
        StepTwo? stepTwo,
        StepThree? stepThree,
    }) => 
        AddCarModelHive(
            stepOne: stepOne ?? this.stepOne,
            stepTwo: stepTwo ?? this.stepTwo,
            stepThree: stepThree ?? this.stepThree,
        );

    factory AddCarModelHive.fromJson(Map<String, dynamic> json) => AddCarModelHive(
        stepOne: json["step_one"] == null ? null : StepOne.fromJson(json["step_one"]),
        stepTwo: json["step_two"] == null ? null : StepTwo.fromJson(json["step_two"]),
        stepThree: json["step_three"] == null ? null : StepThree.fromJson(json["step_three"]),
    );

    Map<String, dynamic> toJson() => {
        "step_one": stepOne?.toJson(),
        "step_two": stepTwo?.toJson(),
        "step_three": stepThree?.toJson(),
    };
}

class StepOne {
    AddMedia? addMedia;
    List<Body>? make;
    List<Body>? serie;
    List<Body>? variation;
    List<Year>? year;
    List<Body>? body;
    List<Body>? mileage;
    List<Body>? fuel;
    List<Body>? transmission;
    List<Body>? exteriorColor;
    List<Body>? condition;

    StepOne({
        this.addMedia,
        this.make,
        this.serie,
        this.variation,
        this.year,
        this.body,
        this.mileage,
        this.fuel,
        this.transmission,
        this.exteriorColor,
        this.condition,
    });

    StepOne copyWith({
        AddMedia? addMedia,
        List<Body>? make,
        List<Body>? serie,
        List<Body>? variation,
        List<Year>? year,
        List<Body>? body,
        List<Body>? mileage,
        List<Body>? fuel,
        List<Body>? transmission,
        List<Body>? exteriorColor,
        List<Body>? condition,
    }) => 
        StepOne(
            addMedia: addMedia ?? this.addMedia,
            make: make ?? this.make,
            serie: serie ?? this.serie,
            variation: variation ?? this.variation,
            year: year ?? this.year,
            body: body ?? this.body,
            mileage: mileage ?? this.mileage,
            fuel: fuel ?? this.fuel,
            transmission: transmission ?? this.transmission,
            exteriorColor: exteriorColor ?? this.exteriorColor,
            condition: condition ?? this.condition,
        );

    factory StepOne.fromJson(Map<String, dynamic> json) => StepOne(
        addMedia: json["add_media"] == null ? null : AddMedia.fromJson(json["add_media"]),
        make: json["make"] == null ? [] : List<Body>.from(json["make"]!.map((x) => Body.fromJson(x))),
        serie: json["serie"] == null ? [] : List<Body>.from(json["serie"]!.map((x) => Body.fromJson(x))),
        variation: json["variation"] == null ? [] : List<Body>.from(json["variation"]!.map((x) => Body.fromJson(x))),
        year: json["year"] == null ? [] : List<Year>.from(json["year"]!.map((x) => Year.fromJson(x))),
        body: json["body"] == null ? [] : List<Body>.from(json["body"]!.map((x) => Body.fromJson(x))),
        mileage: json["mileage"] == null ? [] : List<Body>.from(json["mileage"]!.map((x) => Body.fromJson(x))),
        fuel: json["fuel"] == null ? [] : List<Body>.from(json["fuel"]!.map((x) => Body.fromJson(x))),
        transmission: json["transmission"] == null ? [] : List<Body>.from(json["transmission"]!.map((x) => Body.fromJson(x))),
        exteriorColor: json["exterior-color"] == null ? [] : List<Body>.from(json["exterior-color"]!.map((x) => Body.fromJson(x))),
        condition: json["condition"] == null ? [] : List<Body>.from(json["condition"]!.map((x) => Body.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "add_media": addMedia?.toJson(),
        "make": make == null ? [] : List<dynamic>.from(make!.map((x) => x.toJson())),
        "serie": serie == null ? [] : List<dynamic>.from(serie!.map((x) => x.toJson())),
        "variation": variation == null ? [] : List<dynamic>.from(variation!.map((x) => x.toJson())),
        "year": year == null ? [] : List<dynamic>.from(year!.map((x) => x.toJson())),
        "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
        "mileage": mileage == null ? [] : List<dynamic>.from(mileage!.map((x) => x.toJson())),
        "fuel": fuel == null ? [] : List<dynamic>.from(fuel!.map((x) => x.toJson())),
        "transmission": transmission == null ? [] : List<dynamic>.from(transmission!.map((x) => x.toJson())),
        "exterior-color": exteriorColor == null ? [] : List<dynamic>.from(exteriorColor!.map((x) => x.toJson())),
        "condition": condition == null ? [] : List<dynamic>.from(condition!.map((x) => x.toJson())),
    };
}

class AddMedia {
    String? label;
    List<dynamic>? data;

    AddMedia({
        this.label,
        this.data,
    });

    AddMedia copyWith({
        String? label,
        List<dynamic>? data,
    }) => 
        AddMedia(
            label: label ?? this.label,
            data: data ?? this.data,
        );

    factory AddMedia.fromJson(Map<String, dynamic> json) => AddMedia(
        label: json["label"],
        data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    };
}

class Body {
    String? label;
    String? slug;
    int? count;
    String? logo;
    String? parent;

    Body({
        this.label,
        this.slug,
        this.count,
        this.logo,
        this.parent,
    });

    Body copyWith({
        String? label,
        String? slug,
        int? count,
        String? logo,
        String? parent,
    }) => 
        Body(
            label: label ?? this.label,
            slug: slug ?? this.slug,
            count: count ?? this.count,
            logo: logo ?? this.logo,
            parent: parent ?? this.parent,
        );

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        label: json["label"],
        slug: json["slug"],
        count: json["count"],
        logo: json["logo"],
        parent: json["parent"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "slug": slug,
        "count": count,
        "logo": logo,
        "parent": parent,
    };
}

class Year {
    String? label;
    String? value;
    String? slug;
    int? count;

    Year({
        this.label,
        this.value,
        this.slug,
        this.count,
    });

    Year copyWith({
        String? label,
        String? value,
        String? slug,
        int? count,
    }) => 
        Year(
            label: label ?? this.label,
            value: value ?? this.value,
            slug: slug ?? this.slug,
            count: count ?? this.count,
        );

    factory Year.fromJson(Map<String, dynamic> json) => Year(
        label: json["label"],
        value: json["value"],
        slug: json["slug"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "slug": slug,
        "count": count,
    };
}

class StepThree {
    List<Body>? stmAdditionalFeatures;

    StepThree({
        this.stmAdditionalFeatures,
    });

    StepThree copyWith({
        List<Body>? stmAdditionalFeatures,
    }) => 
        StepThree(
            stmAdditionalFeatures: stmAdditionalFeatures ?? this.stmAdditionalFeatures,
        );

    factory StepThree.fromJson(Map<String, dynamic> json) => StepThree(
        stmAdditionalFeatures: json["stm_additional_features"] == null ? [] : List<Body>.from(json["stm_additional_features"]!.map((x) => Body.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "stm_additional_features": stmAdditionalFeatures == null ? [] : List<dynamic>.from(stmAdditionalFeatures!.map((x) => x.toJson())),
    };
}

class StepTwo {
    List<Body>? registeredIn;
    AddMedia? location;
    List<Year>? price;
    AddMedia? sellerNotes;

    StepTwo({
        this.registeredIn,
        this.location,
        this.price,
        this.sellerNotes,
    });

    StepTwo copyWith({
        List<Body>? registeredIn,
        AddMedia? location,
        List<Year>? price,
        AddMedia? sellerNotes,
    }) => 
        StepTwo(
            registeredIn: registeredIn ?? this.registeredIn,
            location: location ?? this.location,
            price: price ?? this.price,
            sellerNotes: sellerNotes ?? this.sellerNotes,
        );

    factory StepTwo.fromJson(Map<String, dynamic> json) => StepTwo(
        registeredIn: json["registered-in"] == null ? [] : List<Body>.from(json["registered-in"]!.map((x) => Body.fromJson(x))),
        location: json["location"] == null ? null : AddMedia.fromJson(json["location"]),
        price: json["price"] == null ? [] : List<Year>.from(json["price"]!.map((x) => Year.fromJson(x))),
        sellerNotes: json["seller_notes"] == null ? null : AddMedia.fromJson(json["seller_notes"]),
    );

    Map<String, dynamic> toJson() => {
        "registered-in": registeredIn == null ? [] : List<dynamic>.from(registeredIn!.map((x) => x.toJson())),
        "location": location?.toJson(),
        "price": price == null ? [] : List<dynamic>.from(price!.map((x) => x.toJson())),
        "seller_notes": sellerNotes?.toJson(),
    };
}
