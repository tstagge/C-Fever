'''---------------------------IMPORT STATEMENTS----------------------------'''
import regression #Uses objects of the class 'lsrl' within 'regression'
import optimization
#import math

'''--------------------------FUNCTION DEFINITIONS--------------------------'''

#An object is created so as to limit the number of function calls and passed
#  arguments in the driver module; this class is hard-coded for 3 variables,
#  specifically the variables used by the rest of the bioprinter computational
#  model
class cottersMethod(object): #NOTE: this class is hard-coded for 3 factors
	
	#These lists will contain the "-1" and "+1" values for each variable (the
	#  lower bound and upper bound, respectively) in indeces 0 and 1, resp.
	temperatureBounds = []
	speedBounds = []
	apertureBounds = []
	
	#For each of the following lists, t = [0], s = [1], a = [2]
	singleEffects = [0, 0, 0]	
	interactionEffects = [0, 0, 0]	
	effectMeasures = [0, 0, 0]
	sumEffectMeasures = 0 #I am an idoit; why did I have this set to -1?
	normEffectMeasures = [0, 0, 0]
	
	#Transpose of the standard trial matrix (where each row is each variable
	#  and each column is each trial; the matrix that determines the use of
	#  upper and lower bounds and is referenced in all the sensitivity formulae
	trials = [
		[-1, -1, -1], #j = 1
		[+1, -1, -1], #j = 2
		[-1, +1, -1], #j = 3
		[-1, -1, +1], #j = 4 = n+1
		[-1, +1, +1], #j = 5 = n+2
		[+1, -1, +1], #j = 6 = n+3
		[+1, +1, -1], #j = 7 = 2n+1
		[+1, +1, +1] #j = 8 = 2n+2 = 2^n
		]
	
	'''INITIALIZATION'''
	
	#This is the initialization function automatically run when a new object is
	#  created; automatically runs all functions to calculate all of relevant
	#  values using the Cotter's Method functions
	def __init__(self, tEqn, sEqn, aEqn, maxDimError):
	    
	    #Gets the same bounds as used in the quickOpt() optimization routine.
	    #  These bounds are used by the getY() function which is used to calc
	    #  dimensional error at each combination of boundary conditions
		self.temperatureBounds = [4, 36] #Physical limit on the printer
		self.speedBounds = optimization.getBounds(sEqn, maxDimError)
		self.apertureBounds = optimization.getBounds(aEqn, maxDimError)
		
		self.singleEffects[0] = self.getSingleEffect(1, tEqn, sEqn, aEqn)
		self.singleEffects[1] = self.getSingleEffect(2, tEqn, sEqn, aEqn)
		self.singleEffects[2] = self.getSingleEffect(3, tEqn, sEqn, aEqn)
		
		self.interactionEffects[0] = self.getInterEffect(1, tEqn, sEqn, aEqn)
		self.interactionEffects[1] = self.getInterEffect(2, tEqn, sEqn, aEqn)
		self.interactionEffects[2] = self.getInterEffect(3, tEqn, sEqn, aEqn)
		
		self.effectMeasures[0] = self.getEffectMeasure(1, tEqn, sEqn, aEqn)
		self.effectMeasures[1] = self.getEffectMeasure(2, tEqn, sEqn, aEqn)
		self.effectMeasures[2] = self.getEffectMeasure(3, tEqn, sEqn, aEqn)
		
		for m in self.effectMeasures:
			self.sumEffectMeasures += m
		
		self.normEffectMeasures[0] = self.getNormEffect(1, tEqn, sEqn, aEqn)
		self.normEffectMeasures[1] = self.getNormEffect(2, tEqn, sEqn, aEqn)
		self.normEffectMeasures[2] = self.getNormEffect(3, tEqn, sEqn, aEqn)
	
	'''CONSTRUCTION FUNCTIONS'''
	#Helper functions called by __init__() to calculate all relevant values
	
	#Pass true j (function will convert to usable index)
	def getY(self, j, tEq, sEq, aEq):
		trial = j - 1
		tErr = 0
		sErr = 0
		aErr = 0
		if (self.trials[trial][0] == -1):
			tErr = tEq.getValue(self.temperatureBounds[0])
		else:
			tErr = tEq.getValue(self.temperatureBounds[1])
		
		if (self.trials[trial][1] == -1):
			sErr = sEq.getValue(self.speedBounds[0])
		else:
			sErr = sEq.getValue(self.speedBounds[1])
		
		if (self.trials[trial][2] == -1):
			aErr = aEq.getValue(self.apertureBounds[0])
		else:
			aErr = aEq.getValue(self.apertureBounds[1])
		
		return (tErr + sErr + aErr) #Returns dimensional error
	
	#Pass true i; returns the "single effects" which describe how dimensional
	#  error changes when only the given variable is modified, we think
	def getSingleEffect(self, i, tEq, sEq, aEq):
	    #Formula broken up into different lines for readibility
		term1 = self.getY(8, tEq, sEq, aEq) - self.getY(i + 4, tEq, sEq, aEq)
		term2 = self.getY(i + 1, tEq, sEq, aEq) - self.getY(1, tEq, sEq, aEq)
		cO = (1 / 4) * (term1 + term2)
		return cO
	
	#Pass true i; returns "interaction effects" which describe how dimensional
	#  error changes when multiple variables are modified, we think
	def getInterEffect(self, i, tEq, sEq, aEq):
	    #Formula broken up into different lines for readibility
		term1 = self.getY(8, tEq, sEq, aEq) + self.getY(i + 4, tEq, sEq, aEq)
		term2 = self.getY(i + 1, tEq, sEq, aEq) + self.getY(1, tEq, sEq, aEq)
		cO = (1 / 4) * (term1 + term2)
		return cO
	
	#Pass true i; returns the "effect measure" of the given variable
	def getEffectMeasure(self, i, tEq, sEq, aEq):
	    #Formula broken up into different lines for readibility
		index = i - 1 #Converts true i to usable index
		single = abs(self.singleEffects[index])
		inter = abs(self.singleEffects[index])
		m = single + inter
		return m
	
	#Pass true i; returns the "normalized effect measure" of the given variable
	#  which ought to allow easy comparison between variables to determine
	#  which is the most sensitive
	def getNormEffect(self, i, tEq, sEq, aEq):
		index = i - 1 #Converts true i to usable index
		s = self.effectMeasures[index] / self.sumEffectMeasures
		return s
	
	'''PRIVATE FUNCTIONS'''
	#Not truly private, but simply helper functions that are not automatically
	# called by the constructor ( __init__() )
	
	#Returns string denoting which variable is the most sensitive (has greatest
	# effect on dimensional error)
	def getMostSensitive(self):
		mostSensitive = "NULL"
		if (self.normEffectMeasures[0] >= max(self.normEffectMeasures[1], 
			self.normEffectMeasures[2]) ):
			mostSensitive = "Temperature"
		elif (self.normEffectMeasures[1] >= max(self.normEffectMeasures[0], 
			self.normEffectMeasures[2]) ):
			mostSensitive = "Speed"
		elif (self.normEffectMeasures[2] >= max(self.normEffectMeasures[0], 
			self.normEffectMeasures[1]) ):
			mostSensitive = "Aperture"
		
		return mostSensitive
	
	'''PUBLIC FUNCTIONS'''
	#Not truly public, but the only function(s) called from outside the class
	
	def getReport(self):
		reportList = [self.normEffectMeasures[0], self.normEffectMeasures[1], 
		    self.normEffectMeasures[2], self.getMostSensitive()]
		return reportList
		