//
// GenderByName.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GenderByNameInput : MLFeatureProvider {

    /// First name features seperated by first 3 and last 3 letters as Dictionary [String:Double] as dictionary of strings to doubles
    var input: [String : Double]

    var featureNames: Set<String> {
        get {
            return ["input"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input") {
            return try! MLFeatureValue(dictionary: input as [NSObject : NSNumber])
        }
        return nil
    }
    
    init(input: [String : Double]) {
        self.input = input
    }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GenderByNameOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// The most likely gender, for the given input. (F|M) as string value
    lazy var classLabel: String = {
        [unowned self] in return self.provider.featureValue(for: "classLabel")!.stringValue
    }()

    /// The probabilities gender, based on input. as dictionary of strings to doubles
    lazy var classProbability: [String : Double] = {
        [unowned self] in return self.provider.featureValue(for: "classProbability")!.dictionaryValue as! [String : Double]
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(classLabel: String, classProbability: [String : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["classLabel" : MLFeatureValue(string: classLabel), "classProbability" : MLFeatureValue(dictionary: classProbability as [AnyHashable : NSNumber])])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GenderByName {
    var model: MLModel

/// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: GenderByName.self)
        return bundle.url(forResource: "GenderByName", withExtension:"mlmodelc")!
    }

    /**
        Construct a model with explicit path to mlmodelc file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration
        - parameters:
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct a model with explicit path to mlmodelc file and configuration
        - parameters:
           - url: the file url of the model
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
        self.model = try MLModel(contentsOf: url, configuration: configuration)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as GenderByNameInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as GenderByNameOutput
    */
    func prediction(input: GenderByNameInput) throws -> GenderByNameOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as GenderByNameInput
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as GenderByNameOutput
    */
    func prediction(input: GenderByNameInput, options: MLPredictionOptions) throws -> GenderByNameOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return GenderByNameOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - input: First name features seperated by first 3 and last 3 letters as Dictionary [String:Double] as dictionary of strings to doubles
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as GenderByNameOutput
    */
    func prediction(input: [String : Double]) throws -> GenderByNameOutput {
        let input_ = GenderByNameInput(input: input)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface
        - parameters:
           - inputs: the inputs to the prediction as [GenderByNameInput]
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as [GenderByNameOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [GenderByNameInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [GenderByNameOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [GenderByNameOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  GenderByNameOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
