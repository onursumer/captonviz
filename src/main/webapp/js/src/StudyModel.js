var CancerStudy = Backbone.Model.extend({
	initialize: function(attributes) {
		this.studyId = attributes.studyId;
        this.studyName = attributes.studyName;
	}
});

var Method = Backbone.Model.extend({
	initialize: function(attributes) {
		this.methodId = attributes.methodId;
        this.methodName = attributes.methodName;
	}
});

var StudyData = Backbone.Model.extend({
	initialize: function(attributes)
	{
		this.edges = attributes.edges;
        this.nodes = attributes.nodes;
	},
	url: function()
	{
		return "study/get/" +
			this.get("studyId") + "/" +
			this.get("method") + "/" +
			this.get("size");
    }
});

var CancerStudies = Backbone.Collection.extend({
    model: CancerStudy,
    url: "study/list"
});

var Methods = Backbone.Collection.extend({
    model: Method,
    url: "study/methods"
});
